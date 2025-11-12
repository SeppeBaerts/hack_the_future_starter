import 'package:flutter_test/flutter_test.dart';
import 'package:hack_the_future_starter/services/mcp_config.dart';

void main() {
  group('McpConfig', () {
    test('disabled config should not be valid', () {
      final config = McpConfig.disabled();
      
      expect(config.enabled, false);
      expect(config.isValid, false);
    });

    test('production config should be valid', () {
      final config = McpConfig.production();
      
      expect(config.enabled, true);
      expect(config.isValid, true);
      expect(config.serverUrl, isNotNull);
      expect(config.apiKey, isNotNull);
    });

    test('custom enabled config should be valid', () {
      final config = McpConfig.enabled(
        serverUrl: 'http://test.com/sse',
        apiKey: 'test-key',
      );
      
      expect(config.enabled, true);
      expect(config.isValid, true);
      expect(config.serverUrl, 'http://test.com/sse');
      expect(config.apiKey, 'test-key');
    });

    test('enabled config without required params should not be valid', () {
      final config = McpConfig(enabled: true);
      
      expect(config.enabled, true);
      expect(config.isValid, false);
    });
  });
}
