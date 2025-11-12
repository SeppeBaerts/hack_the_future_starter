import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

/// Service for communicating with the MCP server via SSE
class McpClientService {
  McpClientService({
    required this.serverUrl,
    required this.apiKey,
  }) : _logger = Logger('McpClientService');

  final String serverUrl;
  final String apiKey;
  final Logger _logger;

  /// Call an MCP tool and return the result
  Future<Map<String, dynamic>> callTool({
    required String toolName,
    required Map<String, dynamic> input,
  }) async {
    try {
      _logger.info('Calling MCP tool: $toolName with input: $input');

      // Prepare the request body
      final requestBody = {
        'tool': toolName,
        'input': input,
      };

      // Make HTTP POST request to the MCP server
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        _logger.info('MCP tool $toolName returned successfully');
        return result;
      } else {
        _logger.warning(
          'MCP tool $toolName failed with status ${response.statusCode}: ${response.body}',
        );
        throw McpException(
          'MCP server returned status ${response.statusCode}',
        );
      }
    } on TimeoutException {
      _logger.warning('MCP tool $toolName timed out');
      throw McpException('Request to MCP server timed out');
    } catch (e) {
      _logger.severe('Error calling MCP tool $toolName: $e');
      throw McpException('Failed to call MCP tool: $e');
    }
  }

  /// Get highest waves data from the ocean_highest_waves tool
  Future<List<Map<String, dynamic>>> getHighestWaves({
    required String region,
    required String startDate,
    required String endDate,
  }) async {
    final result = await callTool(
      toolName: 'ocean_highest_waves',
      input: {
        'region': region,
        'start_date': startDate,
        'end_date': endDate,
      },
    );

    // The API returns an array of wave data
    if (result is List) {
      return result.cast<Map<String, dynamic>>();
    } else if (result is Map && result.containsKey('data')) {
      return (result['data'] as List).cast<Map<String, dynamic>>();
    }
    
    return [];
  }

  /// Get salinity trends from the ocean_salinity_trends tool
  Future<List<Map<String, dynamic>>> getSalinityTrends({
    required String region,
    required String startDate,
    required String endDate,
  }) async {
    final result = await callTool(
      toolName: 'ocean_salinity_trends',
      input: {
        'region': region,
        'start_date': startDate,
        'end_date': endDate,
      },
    );

    // The API returns an array of salinity data with date and avg_psu
    if (result is List) {
      return result.cast<Map<String, dynamic>>();
    } else if (result is Map && result.containsKey('data')) {
      return (result['data'] as List).cast<Map<String, dynamic>>();
    }
    
    return [];
  }

  /// Get temperature time series from the ocean_temperature_timeseries tool
  Future<List<Map<String, dynamic>>> getTemperatureTimeSeries({
    required String region,
    required String startDate,
    required String endDate,
  }) async {
    final result = await callTool(
      toolName: 'ocean_temperature_timeseries',
      input: {
        'region': region,
        'start_date': startDate,
        'end_date': endDate,
      },
    );

    // The API returns an array of temperature data with date and avg_c
    if (result is List) {
      return result.cast<Map<String, dynamic>>();
    } else if (result is Map && result.containsKey('data')) {
      return (result['data'] as List).cast<Map<String, dynamic>>();
    }
    
    return [];
  }
}

/// Exception thrown when MCP communication fails
class McpException implements Exception {
  McpException(this.message);
  final String message;

  @override
  String toString() => 'McpException: $message';
}
