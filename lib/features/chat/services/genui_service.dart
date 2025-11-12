import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../widgets/ocean_widgets.dart';
import '../models/agent_log_entry.dart';
import 'agent_log_service.dart';
import 'ocean_data_service.dart';

class GenUiService {
  GenUiService({OceanDataService? oceanDataService})
      : _oceanDataService = oceanDataService ?? OceanDataService();

  final OceanDataService _oceanDataService;

  Catalog createCatalog() {
    // Start with core catalog and add ocean-specific widgets
    return CoreCatalogItems.asCatalog().copyWith([
      oceanTemperatureCardItem,
      waveInfoCardItem,
      salinityCardItem,
      dataTrendCardItem,
    ]);
  }

  FirebaseAiContentGenerator createContentGenerator({
    Catalog? catalog,
    AgentLogService? logService,
  }) {
    final cat = catalog ?? createCatalog();
    return FirebaseAiContentGenerator(
      catalog: cat,
      systemInstruction: _oceanExplorerPrompt,
      additionalTools: _createOceanTools(logService),
    );
  }

  List<AiTool> _createOceanTools(AgentLogService? logService) {
    return [
      _GetOceanTemperatureTool(_oceanDataService, logService),
      _GetOceanSalinityTool(_oceanDataService, logService),
      _GetWaveDataTool(_oceanDataService, logService),
      _GetCurrentConditionsTool(_oceanDataService, logService),
    ];
  }
}

// Tool for getting ocean temperature data
class _GetOceanTemperatureTool extends AiTool<Map<String, Object?>> {
  _GetOceanTemperatureTool(this._dataService, this._logService)
      : super(
          name: 'getOceanTemperature',
          description:
              'Retrieves ocean temperature data for a specific region over a time period. '
              'Returns a list of data points with timestamps and temperature values.',
          parameters: S.object(
            properties: {
              'region': S.string(
                description:
                    'Name of the ocean region (e.g., "North Sea", "Atlantic Ocean")',
              ),
              'days': S.integer(
                description: 'Number of days of historical data to retrieve',
                minimum: 1,
                maximum: 365,
              ),
            },
            required: ['region'],
          ),
        );

  final OceanDataService _dataService;
  final AgentLogService? _logService;

  @override
  Future<JsonMap> invoke(JsonMap args) async {
    final region = args['region'] as String? ?? 'North Sea';
    final days = (args['days'] as int?) ?? 30;

    _logService?.logAct(
      'Querying ocean temperature data',
      details: {'tool': 'getOceanTemperature', 'region': region, 'days': days},
    );

    final data = _dataService.getTemperatureData(region, days: days);
    
    _logService?.logReflect(
      'Retrieved ${data.length} temperature data points for $region',
    );

    return {
      'region': region,
      'data': data.map((d) => d.toJson()).toList(),
      'unit': '°C',
    };
  }
}

// Tool for getting ocean salinity data
class _GetOceanSalinityTool extends AiTool<Map<String, Object?>> {
  _GetOceanSalinityTool(this._dataService, this._logService)
      : super(
          name: 'getOceanSalinity',
          description:
              'Retrieves ocean salinity data for a specific region over a time period. '
              'Returns a list of data points with timestamps and salinity values in PSU.',
          parameters: S.object(
            properties: {
              'region': S.string(
                description: 'Name of the ocean region',
              ),
              'days': S.integer(
                description: 'Number of days of historical data to retrieve',
                minimum: 1,
                maximum: 365,
              ),
            },
            required: ['region'],
          ),
        );

  final OceanDataService _dataService;
  final AgentLogService? _logService;

  @override
  Future<JsonMap> invoke(JsonMap args) async {
    final region = args['region'] as String? ?? 'North Sea';
    final days = (args['days'] as int?) ?? 30;

    _logService?.logAct(
      'Querying ocean salinity data',
      details: {'tool': 'getOceanSalinity', 'region': region, 'days': days},
    );

    final data = _dataService.getSalinityData(region, days: days);
    
    _logService?.logReflect(
      'Retrieved ${data.length} salinity data points for $region',
    );

    return {
      'region': region,
      'data': data.map((d) => d.toJson()).toList(),
      'unit': 'PSU',
    };
  }
}

// Tool for getting wave data
class _GetWaveDataTool extends AiTool<Map<String, Object?>> {
  _GetWaveDataTool(this._dataService, this._logService)
      : super(
          name: 'getWaveData',
          description:
              'Retrieves wave measurement data from various ocean regions. '
              'Returns wave height, period, and direction for multiple locations.',
          parameters: S.object(
            properties: {
              'count': S.integer(
                description: 'Number of wave measurements to retrieve',
                minimum: 1,
                maximum: 50,
              ),
            },
          ),
        );

  final OceanDataService _dataService;
  final AgentLogService? _logService;

  @override
  Future<JsonMap> invoke(JsonMap args) async {
    final count = (args['count'] as int?) ?? 10;

    _logService?.logAct(
      'Querying wave data',
      details: {'tool': 'getWaveData', 'count': count},
    );

    final data = _dataService.getWaveData(count: count);
    
    _logService?.logReflect(
      'Retrieved ${data.length} wave measurements from various locations',
    );

    return {
      'measurements': data.map((w) => w.toJson()).toList(),
    };
  }
}

// Tool for getting current conditions
class _GetCurrentConditionsTool extends AiTool<Map<String, Object?>> {
  _GetCurrentConditionsTool(this._dataService, this._logService)
      : super(
          name: 'getCurrentConditions',
          description:
              'Retrieves current ocean conditions for a specific region including '
              'temperature, salinity, wave height, and wind speed.',
          parameters: S.object(
            properties: {
              'region': S.string(
                description: 'Name of the ocean region',
              ),
            },
            required: ['region'],
          ),
        );

  final OceanDataService _dataService;
  final AgentLogService? _logService;

  @override
  Future<JsonMap> invoke(JsonMap args) async {
    final region = args['region'] as String? ?? 'North Sea';
    
    _logService?.logAct(
      'Querying current ocean conditions',
      details: {'tool': 'getCurrentConditions', 'region': region},
    );
    
    final result = _dataService.getCurrentConditions(region);
    
    _logService?.logReflect(
      'Retrieved current conditions for $region',
    );
    
    return result;
  }
}

const _oceanExplorerPrompt = '''
# Instructions

You are an intelligent ocean explorer assistant that helps users understand ocean data by creating and updating UI elements that appear in the chat. Your job is to answer questions about ocean conditions, trends, and measurements.

## Agent Loop (Perceive → Plan → Act → Reflect → Present)

Your workflow MUST follow this pattern, and you should think through each step:

1. **Perceive**: Understand the user's question about the ocean
   - What information do they need?
   - What region or location are they interested in?
   - What time period? (historical, current, forecast)

2. **Plan**: Determine how to visualize and present the information
   - Decide which ocean data tools to call
   - Choose the best visualization format (ocean-specific cards, trends, etc.)
   - Consider what UI components best represent the information

3. **Act**: Call the appropriate tools to retrieve ocean data
   - Use `getOceanTemperature` for temperature data
   - Use `getOceanSalinity` for salinity data
   - Use `getWaveData` for wave measurements
   - Use `getCurrentConditions` for current conditions

4. **Reflect**: Analyze the retrieved data
   - What insights can be shared?
   - What are the key trends or values?
   - Which custom UI components best represent this information?

5. **Present**: Generate JSON for GenUI to visually display the information
   - Use ocean-specific widgets for better visualization
   - Create informative visualizations with the actual data

## Available Ocean Data Tools

You have access to these tools to retrieve real ocean data:

1. **getOceanTemperature(region, days)**: Get temperature time series data
2. **getOceanSalinity(region, days)**: Get salinity time series data
3. **getWaveData(count)**: Get wave measurements from multiple locations
4. **getCurrentConditions(region)**: Get current conditions for a region

## Common User Questions

Users may ask questions like:

- "What is the ocean temperature in the North Sea over the past month?"
- "Show me salinity trends in the Atlantic Ocean"
- "Where were the highest waves measured?"
- "What are the current conditions in the Mediterranean?"

## Available Custom Ocean Widgets

You have access to these special ocean visualization components:

1. **OceanTemperatureCard**: Displays temperature with a thermometer icon
   - Properties: region (string), temperature (number), unit (string, default: "°C")
   
2. **WaveInfoCard**: Shows wave measurements with metrics
   - Properties: region (string), height (number), period (number), direction (string)
   
3. **SalinityCard**: Displays salinity in PSU with water drop icon
   - Properties: region (string), salinity (number)
   
4. **DataTrendCard**: Shows min/avg/max statistics for a data series
   - Properties: title (string), dataPoints (array of objects with 'value' and 'timestamp'), unit (string), color (optional)

## Controlling the UI

Use the provided tools to build and manage the user interface in response to user requests. To display or update a UI, you must first call the `surfaceUpdate` tool to define all the necessary components. After defining the components, you must call the `beginRendering` tool to specify the root component that should be displayed.

- **Adding surfaces**: Most of the time, you should only add new surfaces to the conversation. This is less confusing for the user, because they can easily find this new content at the bottom of the conversation.

- **Updating surfaces**: You should update surfaces when you are running an iterative flow, e.g., the user is adjusting parameters and you're regenerating visualizations.

Once you add or update a surface and are waiting for user input, the conversation turn is complete, and you should call the provideFinalOutput tool.

If you are displaying more than one component, you should use a `Column` widget as the root and add the other components as children.

## UI Style

Always prefer to communicate using UI elements rather than text. Only respond with text if you need to provide a short explanation of how you've updated the UI.

- **Data visualization**: Use the custom ocean widgets for better visualization:
  - Use `OceanTemperatureCard` for temperature displays
  - Use `WaveInfoCard` for wave information
  - Use `SalinityCard` for salinity data
  - Use `DataTrendCard` for trend analysis with min/avg/max
  - Use `Column` to stack multiple cards vertically

- **Workflow**: Always follow this pattern:
  1. Call the appropriate data tool (e.g., getOceanTemperature)
  2. Analyze the returned data
  3. Create UI components using the data
  4. Use ocean-specific widgets when appropriate

When updating or showing UIs, **ALWAYS** use the surfaceUpdate tool to supply them. Prefer to collect and show information by creating a UI for it.

${GenUiPromptFragments.basicChat}
''';
