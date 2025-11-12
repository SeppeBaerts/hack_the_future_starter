import 'package:flutter/material.dart';
import '../models/agent_log_entry.dart';
import '../services/agent_log_service.dart';

class AgentLogPanel extends StatefulWidget {
  const AgentLogPanel({
    required this.logService,
    super.key,
  });

  final AgentLogService logService;

  @override
  State<AgentLogPanel> createState() => _AgentLogPanelState();
}

class _AgentLogPanelState extends State<AgentLogPanel> {
  final Set<String> _expandedConversations = {};

  Color _getStepColor(AgentStep step) {
    switch (step) {
      case AgentStep.perceive:
        return Colors.purple.shade600;
      case AgentStep.plan:
        return Colors.blue.shade600;
      case AgentStep.act:
        return Colors.orange.shade600;
      case AgentStep.reflect:
        return Colors.green.shade600;
      case AgentStep.present:
        return Colors.indigo.shade600;
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
      animation: widget.logService,
      builder: (context, _) {
        final entries = widget.logService.entries;
        
        if (entries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.psychology_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Agent activity will appear here',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ask a question to see the agent in action',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Group entries by conversation
        final conversationIds = widget.logService.conversationIds;
        
        if (conversationIds.isEmpty) {
          // Show ungrouped entries
          return _buildEntryList(entries);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: conversationIds.length,
          itemBuilder: (context, index) {
            final conversationId = conversationIds[conversationIds.length - 1 - index];
            final conversationEntries = widget.logService.getConversationEntries(conversationId);
            final isExpanded = _expandedConversations.contains(conversationId);
            
            return _buildConversationGroup(
              conversationId,
              conversationEntries,
              isExpanded,
            );
          },
        );
      },
    );
  }

  Widget _buildConversationGroup(
    String conversationId,
    List<AgentLogEntry> entries,
    bool isExpanded,
  ) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final firstEntry = entries.first;
    final userQuery = firstEntry.step == AgentStep.perceive
        ? firstEntry.message
        : 'Query at ${_formatTime(firstEntry.timestamp)}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedConversations.remove(conversationId);
                } else {
                  _expandedConversations.add(conversationId);
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? Icons.expand_more : Icons.chevron_right,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userQuery.replaceFirst('User asked: ', '').replaceAll('"', ''),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${entries.length} steps • ${_formatTime(firstEntry.timestamp)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStepSummary(entries),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Column(
                children: entries.map((entry) => _buildLogEntry(entry)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepSummary(List<AgentLogEntry> entries) {
    final stepCounts = <AgentStep, int>{};
    for (final entry in entries) {
      stepCounts[entry.step] = (stepCounts[entry.step] ?? 0) + 1;
    }

    return Wrap(
      spacing: 4,
      children: stepCounts.entries.map((e) {
        final color = _getStepColor(e.key);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${e.value}',
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLogEntry(AgentLogEntry entry) {
    final color = _getStepColor(entry.step);
    final icon = _getStepIcon(entry.step);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon.icon,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.stepName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDetailedTime(entry.timestamp),
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  entry.message,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
                if (entry.details != null && entry.details!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.details.toString(),
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryList(List<AgentLogEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return _buildLogEntry(entries[index]);
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
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDetailedTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
