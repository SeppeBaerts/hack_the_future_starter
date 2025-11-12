# MCP Server Integration

This document describes the MCP (Model Context Protocol) server integration for fetching real ocean data.

## Overview

The app now supports fetching real ocean data from an MCP server endpoint instead of using mock data. The integration is designed to be non-intrusive with automatic fallback to mock data if the MCP server is unavailable.

## Configuration

The MCP integration is configured in `lib/services/mcp_config.dart`. Three configuration modes are available:

### 1. Production Mode (Default)
Uses the production MCP server:
```dart
final config = McpConfig.production();
```

### 2. Custom Configuration
```dart
final config = McpConfig.enabled(
  serverUrl: 'http://your-server:8788/sse',
  apiKey: 'your-api-key',
);
```

### 3. Disabled (Mock Data Only)
```dart
final config = McpConfig.disabled();
```

To change the configuration, edit `lib/features/chat/view/chat_screen.dart` in the `initState` method.

## MCP Tools

The following MCP tools are integrated:

### 1. ocean_temperature_timeseries
Fetches ocean temperature data over a time period.

**Input:**
- `region` (string): Ocean region name (e.g., "Atlantische Oceaan", "Noordzee")
- `start_date` (string): Start date in yyyy-mm-dd format
- `end_date` (string): End date in yyyy-mm-dd format

**Output:**
```json
[
  {
    "date": "2025-10-12",
    "avg_c": 22.29
  }
]
```

### 2. ocean_salinity_trends
Fetches ocean salinity trends over a time period.

**Input:**
- `region` (string): Ocean region name
- `start_date` (string): Start date in yyyy-mm-dd format
- `end_date` (string): End date in yyyy-mm-dd format

**Output:**
```json
[
  {
    "date": "2025-10-12",
    "avg_psu": 35.98
  }
]
```

### 3. ocean_highest_waves
Fetches the highest wave measurements in a region.

**Input:**
- `region` (string): Ocean region name
- `start_date` (string): Start date in yyyy-mm-dd format
- `end_date` (string): End date in yyyy-mm-dd format

**Output:**
```json
[
  {
    "timestamp": "2025-10-30T10:49:28.052867+00:00",
    "wave_height_m": 18.2,
    "region": "Atlantische Oceaan",
    "lat": 45,
    "lon": -30
  }
]
```

## Region Names

The MCP API expects Dutch region names. The integration automatically converts common English names to Dutch:

- "North Sea" → "Noordzee"
- "Atlantic Ocean" → "Atlantische Oceaan"
- "Pacific Ocean" → "Stille Oceaan"
- "Mediterranean Sea" → "Middellandse Zee"
- "Baltic Sea" → "Oostzee"

## Fallback Behavior

If the MCP server is unavailable or returns an error, the app automatically falls back to mock data. This ensures the app continues to work even when:

- MCP server is down
- Network connectivity issues occur
- API rate limits are reached
- Authentication fails

Error messages are logged to the console for debugging.

## Architecture

```
ChatScreen
    ↓
ChatViewModel
    ↓
GenUiService (with McpConfig)
    ↓
OceanDataService (with optional McpClientService)
    ↓
McpClientService → MCP Server (HTTP GET)
    ↓
Real Ocean Data (or fallback to mock data)
```

## Files Modified

1. **lib/services/mcp_client_service.dart** (new)
   - HTTP client for MCP server communication
   - Tool-specific methods for each ocean data type

2. **lib/services/mcp_config.dart** (new)
   - Configuration management for MCP integration
   - Production, custom, and disabled modes

3. **lib/features/chat/services/ocean_data_service.dart**
   - Updated to accept optional MCP client
   - Added async methods with MCP-first, mock-fallback logic
   - Region name translation (English → Dutch)

4. **lib/features/chat/services/genui_service.dart**
   - Updated to accept McpConfig
   - Initializes MCP client when config is valid
   - Updated tool methods to await async data calls

5. **lib/features/chat/view/chat_screen.dart**
   - Initializes GenUiService with production MCP config

## Testing

To test the MCP integration:

1. Run the app with production config (default)
2. Ask questions like:
   - "What is the ocean temperature in the Atlantic Ocean?"
   - "Show me salinity trends in the North Sea"
   - "Where are the highest waves?"

The app will attempt to fetch real data from the MCP server and fall back to mock data if unavailable.

To test with mock data only, change the config to `McpConfig.disabled()`.
