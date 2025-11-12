/// Configuration for MCP server integration
class McpConfig {
  McpConfig({
    required this.enabled,
    this.serverUrl,
    this.apiKey,
  });

  /// Whether MCP integration is enabled
  final bool enabled;

  /// URL of the MCP server (SSE endpoint)
  final String? serverUrl;

  /// API key for authentication
  final String? apiKey;

  /// Create a default config with MCP disabled (falls back to mock data)
  factory McpConfig.disabled() {
    return McpConfig(enabled: false);
  }

  /// Create a config with MCP enabled
  factory McpConfig.enabled({
    required String serverUrl,
    required String apiKey,
  }) {
    return McpConfig(
      enabled: true,
      serverUrl: serverUrl,
      apiKey: apiKey,
    );
  }

  /// Default production config using the provided MCP endpoint
  factory McpConfig.production() {
    return McpConfig.enabled(
      serverUrl: 'http://10.7.0.46:8788/sse',
      apiKey: 'team_abyss_explorers_66dd6c0f556a7113',
    );
  }

  bool get isValid => enabled && serverUrl != null && apiKey != null;
}
