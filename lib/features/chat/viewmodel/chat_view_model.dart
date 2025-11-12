import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:hack_the_future_starter/features/chat/models/chat_message.dart';
import 'package:hack_the_future_starter/features/chat/models/agent_log_entry.dart';
import 'package:hack_the_future_starter/features/chat/services/genui_service.dart';
import 'package:hack_the_future_starter/features/chat/services/agent_log_service.dart';
import 'package:hack_the_future_starter/features/chat/services/cancellable_content_generator.dart';
import 'package:hack_the_future_starter/features/chat/services/query_history_service.dart';
import 'package:hack_the_future_starter/features/chat/services/favorites_service.dart';
import 'package:hack_the_future_starter/features/chat/services/screenshot_service.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({
    GenUiService? service,
    AgentLogService? agentLogService,
    QueryHistoryService? queryHistoryService,
    FavoritesService? favoritesService,
    ScreenshotService? screenshotService,
  })  : _service = service ?? GenUiService(),
        agentLogService = agentLogService ?? AgentLogService(),
        queryHistoryService = queryHistoryService ?? QueryHistoryService(),
        favoritesService = favoritesService ?? FavoritesService(),
        screenshotService = screenshotService ?? ScreenshotService();

  final GenUiService _service;
  final AgentLogService agentLogService;
  final QueryHistoryService queryHistoryService;
  final FavoritesService favoritesService;
  final ScreenshotService screenshotService;

  late final Catalog _catalog;
  late final GenUiManager _manager;
  late final GenUiConversation _conversation;
  late final CancellableContentGenerator _cancellableGenerator;

  GenUiHost get host => _conversation.host;

  ValueListenable<bool> get isProcessing => _conversation.isProcessing;

  final List<ChatMessageModel> _messages = [];
  bool _isAborting = false;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  
  bool get isAborting => _isAborting;

  void init() {
    _catalog = _service.createCatalog();
    _manager = GenUiManager(catalog: _catalog);
    final generator = _service.createContentGenerator(
      catalog: _catalog,
      logService: agentLogService,
    );
    
    // Wrap the generator with cancellation support
    _cancellableGenerator = CancellableContentGenerator(generator);

    _conversation = GenUiConversation(
      genUiManager: _manager,
      contentGenerator: _cancellableGenerator,
      onSurfaceAdded: (s) {
        agentLogService.logPresent('Created UI surface with widgets');
        _messages.add(ChatMessageModel(surfaceId: s.surfaceId));
        notifyListeners();
      },
      onTextResponse: (text) {
        _messages.add(ChatMessageModel(text: text));
        notifyListeners();
      },
      onError: (err) {
        agentLogService.addEntry(
          AgentStep.act,
          'Error: ${err.error}',
        );
        _messages.add(
          ChatMessageModel(text: err.error.toString(), isError: true),
        );
        notifyListeners();
      },
    );
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    
    // Reset abort flag for new request
    _isAborting = false;
    
    // Add to query history
    queryHistoryService.addQuery(text);
    notifyListeners(); // Notify to update query history UI
    
    // Start a new conversation context (but don't clear old logs)
    agentLogService.startNewConversation();
    
    // Log the user's question
    agentLogService.logPerceive('User asked: "$text"');
    
    _messages.add(ChatMessageModel(text: text, isUser: true));
    notifyListeners();
    
    await _conversation.sendRequest(UserMessage([TextPart(text)]));
  }

  void abort() {
    // Prevent multiple abort calls
    if (_isAborting) return;
    
    _isAborting = true;
    
    agentLogService.addEntry(
      AgentStep.act,
      'User requested to stop the agent',
    );
    
    // Cancel the current request
    _cancellableGenerator.cancel();
  }

  void toggleFavorite(String query, {String? surfaceId}) {
    if (favoritesService.isFavorited(query)) {
      final favorite = favoritesService.getFavoriteByQuery(query);
      if (favorite != null) {
        favoritesService.removeFavorite(favorite.id);
      }
    } else {
      favoritesService.addFavorite(query, surfaceId: surfaceId);
    }
    notifyListeners();
  }

  void disposeConversation() {
    _conversation.dispose();
  }
}
