import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';
import 'package:hack_the_future_starter/features/chat/models/chat_message.dart';
import 'package:hack_the_future_starter/features/chat/models/agent_log_entry.dart';
import 'package:hack_the_future_starter/features/chat/services/genui_service.dart';
import 'package:hack_the_future_starter/features/chat/services/agent_log_service.dart';
import 'package:hack_the_future_starter/features/chat/services/query_history_service.dart';
import 'package:hack_the_future_starter/features/chat/services/favorites_service.dart';
import 'package:hack_the_future_starter/features/chat/services/share_service.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({
    GenUiService? service,
    AgentLogService? agentLogService,
    QueryHistoryService? queryHistoryService,
    FavoritesService? favoritesService,
    ShareService? shareService,
  })  : _service = service ?? GenUiService(),
        agentLogService = agentLogService ?? AgentLogService(),
        queryHistoryService = queryHistoryService ?? QueryHistoryService(),
        favoritesService = favoritesService ?? FavoritesService(),
        shareService = shareService ?? ShareService();

  final GenUiService _service;
  final AgentLogService agentLogService;
  final QueryHistoryService queryHistoryService;
  final FavoritesService favoritesService;
  final ShareService shareService;

  late final Catalog _catalog;
  late final GenUiManager _manager;
  late final GenUiConversation _conversation;

  GenUiHost get host => _conversation.host;

  ValueListenable<bool> get isProcessing => _conversation.isProcessing;

  final List<ChatMessageModel> _messages = [];

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);

  void init() {
    _catalog = _service.createCatalog();
    _manager = GenUiManager(catalog: _catalog);
    final generator = _service.createContentGenerator(catalog: _catalog);

    _conversation = GenUiConversation(
      genUiManager: _manager,
      contentGenerator: generator,
      onSurfaceAdded: (s) {
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
    
    // Clear previous logs for new query
    agentLogService.clear();
    
    // Add to history
    queryHistoryService.addQuery(text);
    
    // Log the user's question
    agentLogService.logPerceive('User asked: "$text"');
    
    _messages.add(ChatMessageModel(text: text, isUser: true));
    notifyListeners();
    
    await _conversation.sendRequest(UserMessage([TextPart(text)]));
  }

  void abort() {
    // Note: GenUI doesn't directly expose abort, but we can track this
    agentLogService.addEntry(
      AgentStep.act,
      'User requested to stop the agent',
    );
    // The conversation will naturally stop after current processing
  }

  void disposeConversation() {
    _conversation.dispose();
  }
}
