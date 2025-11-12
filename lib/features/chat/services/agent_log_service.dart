import 'package:flutter/foundation.dart';
import '../models/agent_log_entry.dart';

class AgentLogService extends ChangeNotifier {
  final List<AgentLogEntry> _entries = [];
  String? _currentConversationId;

  List<AgentLogEntry> get entries => List.unmodifiable(_entries);
  String? get currentConversationId => _currentConversationId;

  /// Start a new conversation context
  void startNewConversation() {
    _currentConversationId = DateTime.now().millisecondsSinceEpoch.toString();
    notifyListeners();
  }

  void addEntry(
    AgentStep step,
    String message, {
    Map<String, dynamic>? details,
  }) {
    _entries.add(AgentLogEntry(
      step: step,
      message: message,
      timestamp: DateTime.now(),
      conversationId: _currentConversationId,
      details: details,
    ));
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    _currentConversationId = null;
    notifyListeners();
  }

  void logPerceive(String message, {Map<String, dynamic>? details}) =>
      addEntry(AgentStep.perceive, message, details: details);
  void logPlan(String message, {Map<String, dynamic>? details}) =>
      addEntry(AgentStep.plan, message, details: details);
  void logAct(String message, {Map<String, dynamic>? details}) =>
      addEntry(AgentStep.act, message, details: details);
  void logReflect(String message, {Map<String, dynamic>? details}) =>
      addEntry(AgentStep.reflect, message, details: details);
  void logPresent(String message, {Map<String, dynamic>? details}) =>
      addEntry(AgentStep.present, message, details: details);

  /// Get entries for a specific conversation
  List<AgentLogEntry> getConversationEntries(String conversationId) {
    return _entries
        .where((entry) => entry.conversationId == conversationId)
        .toList();
  }

  /// Get all unique conversation IDs
  List<String> get conversationIds {
    return _entries
        .map((e) => e.conversationId)
        .where((id) => id != null)
        .cast<String>()
        .toSet()
        .toList();
  }
}
