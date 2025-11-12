import 'package:flutter/material.dart';
import '../models/agent_log_entry.dart';
import '../services/agent_log_service.dart';

class AgentLogPanel extends StatelessWidget {
  const AgentLogPanel({
    required this.logService,
    super.key,
  });

  final AgentLogService logService;

  Color _getStepColor(AgentStep step) {
    switch (step) {
      case AgentStep.perceive:
        return Colors.purple;
      case AgentStep.plan:
        return Colors.blue;
      case AgentStep.act:
        return Colors.orange;
      case AgentStep.reflect:
        return Colors.green;
      case AgentStep.present:
        return Colors.indigo;
    }
  }

  Icon _getStepIcon(AgentStep step) {
    switch (step) {
      case AgentStep.perceive:
        return const Icon(Icons.visibility, size: 16);
      case AgentStep.plan:
        return const Icon(Icons.architecture, size: 16);
      case AgentStep.act:
        return const Icon(Icons.play_arrow, size: 16);
      case AgentStep.reflect:
        return const Icon(Icons.lightbulb, size: 16);
      case AgentStep.present:
        return const Icon(Icons.present_to_all, size: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: logService,
      builder: (context, _) {
        final entries = logService.entries;
        
        if (entries.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Agent log will appear here...',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          reverse: false,
          padding: const EdgeInsets.all(8.0),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final color = _getStepColor(entry.step);
            final icon = _getStepIcon(entry.step);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                dense: true,
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  foregroundColor: color,
                  radius: 16,
                  child: icon,
                ),
                title: Text(
                  entry.stepName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                ),
                subtitle: Text(
                  entry.message,
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: Text(
                  _formatTime(entry.timestamp),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
