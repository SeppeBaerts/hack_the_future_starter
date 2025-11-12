import 'package:flutter/material.dart';
import '../services/query_history_service.dart';

class QueryHistoryPanel extends StatelessWidget {
  const QueryHistoryPanel({
    required this.historyService,
    required this.onQuerySelected,
    super.key,
  });

  final QueryHistoryService historyService;
  final Function(String) onQuerySelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: historyService,
      builder: (context, _) {
        final history = historyService.history;

        if (history.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border(
              bottom: BorderSide(color: Colors.blue.shade200),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Recent Queries',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      historyService.clear();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: history.map((item) {
                  return ActionChip(
                    label: Text(
                      item.query,
                      style: const TextStyle(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () => onQuerySelected(item.query),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue.shade200),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
