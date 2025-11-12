import 'package:flutter/foundation.dart';
import '../models/agent_log_entry.dart';

class AgentLogService extends ChangeNotifier {
  final List<AgentLogEntry> _entries = [];

  List<AgentLogEntry> get entries => List.unmodifiable(_entries);

  void addEntry(AgentStep step, String message) {
    _entries.add(AgentLogEntry(
      step: step,
      message: message,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }

  void logPerceive(String message) => addEntry(AgentStep.perceive, message);
  void logPlan(String message) => addEntry(AgentStep.plan, message);
  void logAct(String message) => addEntry(AgentStep.act, message);
  void logReflect(String message) => addEntry(AgentStep.reflect, message);
  void logPresent(String message) => addEntry(AgentStep.present, message);
}
