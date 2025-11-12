import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareService {
  /// Export data to JSON format and copy to clipboard
  Future<void> exportToJson(Map<String, dynamic> data) async {
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    await Clipboard.setData(ClipboardData(text: jsonString));
  }

  /// Export data to CSV format and copy to clipboard
  Future<void> exportToCsv(List<Map<String, dynamic>> data) async {
    if (data.isEmpty) return;

    final headers = data.first.keys.toList();
    final csvRows = <String>[];

    // Add header row
    csvRows.add(headers.join(','));

    // Add data rows
    for (final row in data) {
      final values = headers.map((header) {
        final value = row[header]?.toString() ?? '';
        // Escape commas and quotes in CSV
        if (value.contains(',') || value.contains('"')) {
          return '"${value.replaceAll('"', '""')}"';
        }
        return value;
      }).toList();
      csvRows.add(values.join(','));
    }

    final csvString = csvRows.join('\n');
    await Clipboard.setData(ClipboardData(text: csvString));
  }

  /// Show a share dialog with export options
  Future<void> showShareDialog(
    BuildContext context, {
    Map<String, dynamic>? jsonData,
    List<Map<String, dynamic>>? csvData,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (jsonData != null)
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Copy as JSON'),
                onTap: () async {
                  await exportToJson(jsonData);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('JSON copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            if (csvData != null)
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('Copy as CSV'),
                onTap: () async {
                  await exportToCsv(csvData);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('CSV copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
