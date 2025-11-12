enum AgentStep {
  perceive,
  plan,
  act,
  reflect,
  present,
}

class AgentLogEntry {
  const AgentLogEntry({
    required this.step,
    required this.message,
    required this.timestamp,
    this.conversationId,
    this.details,
  });

  final AgentStep step;
  final String message;
  final DateTime timestamp;
  final String? conversationId;
  final Map<String, dynamic>? details;

  String get stepName {
    switch (step) {
      case AgentStep.perceive:
        return 'Perceive';
      case AgentStep.plan:
        return 'Plan';
      case AgentStep.act:
        return 'Act';
      case AgentStep.reflect:
        return 'Reflect';
      case AgentStep.present:
        return 'Present';
    }
  }
}
