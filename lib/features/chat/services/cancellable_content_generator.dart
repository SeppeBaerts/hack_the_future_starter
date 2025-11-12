import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';

/// A wrapper around ContentGenerator that adds cancellation support.
/// 
/// This wrapper intercepts requests and provides a mechanism to cancel
/// ongoing requests by preventing their results from being emitted.
class CancellableContentGenerator implements ContentGenerator {
  CancellableContentGenerator(this._inner);

  final ContentGenerator _inner;
  
  StreamSubscription<A2uiMessage>? _a2uiSubscription;
  StreamSubscription<String>? _textSubscription;
  StreamSubscription<ContentGeneratorError>? _errorSubscription;
  
  final _a2uiMessageController = StreamController<A2uiMessage>.broadcast();
  final _textResponseController = StreamController<String>.broadcast();
  final _errorController = StreamController<ContentGeneratorError>.broadcast();
  
  bool _isCancelled = false;
  
  @override
  Stream<A2uiMessage> get a2uiMessageStream => _a2uiMessageController.stream;

  @override
  Stream<String> get textResponseStream => _textResponseController.stream;

  @override
  Stream<ContentGeneratorError> get errorStream => _errorController.stream;

  @override
  ValueListenable<bool> get isProcessing => _inner.isProcessing;

  @override
  Future<void> sendRequest(
    ChatMessage message, {
    Iterable<ChatMessage>? history,
  }) async {
    // Reset cancellation flag for new request
    _isCancelled = false;
    
    // Cancel any existing subscriptions
    await _cancelSubscriptions();
    
    // Set up new subscriptions that check cancellation flag
    _a2uiSubscription = _inner.a2uiMessageStream.listen(
      (msg) {
        if (!_isCancelled) {
          _a2uiMessageController.add(msg);
        }
      },
    );
    
    _textSubscription = _inner.textResponseStream.listen(
      (text) {
        if (!_isCancelled) {
          _textResponseController.add(text);
        }
      },
    );
    
    _errorSubscription = _inner.errorStream.listen(
      (error) {
        if (!_isCancelled) {
          _errorController.add(error);
        }
      },
    );
    
    // Send the request to the inner generator
    await _inner.sendRequest(message, history: history);
    
    // If request was cancelled, emit a cancellation message
    if (_isCancelled) {
      _textResponseController.add('Request was cancelled by user.');
    }
  }
  
  /// Cancels the current request.
  /// 
  /// Note: This doesn't stop the underlying API call, but prevents
  /// any results from being emitted to listeners.
  void cancel() {
    _isCancelled = true;
  }
  
  Future<void> _cancelSubscriptions() async {
    await _a2uiSubscription?.cancel();
    await _textSubscription?.cancel();
    await _errorSubscription?.cancel();
    _a2uiSubscription = null;
    _textSubscription = null;
    _errorSubscription = null;
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    _a2uiMessageController.close();
    _textResponseController.close();
    _errorController.close();
    _inner.dispose();
  }
}
