# Agentic Ocean Explorer - Demo Scenarios

## Scenario 1: Temperature Query

**User Query:** "What is the ocean temperature in the North Sea?"

**Agent Steps:**
1. **Perceive**: User wants temperature data for North Sea region
2. **Plan**: Need to call getOceanTemperature tool and display with OceanTemperatureCard
3. **Act**: Call `getOceanTemperature(region: "North Sea", days: 30)`
4. **Reflect**: Data shows average ~12.5°C with slight variations
5. **Present**: Display using OceanTemperatureCard and DataTrendCard

**Expected Output:**
- OceanTemperatureCard showing current temperature (~12.5°C)
- DataTrendCard showing min/avg/max over 30 days

## Scenario 2: Salinity Trends

**User Query:** "Show me salinity trends in the Atlantic Ocean"

**Agent Steps:**
1. **Perceive**: User wants salinity time series for Atlantic Ocean
2. **Plan**: Call getOceanSalinity and show trend statistics
3. **Act**: Call `getOceanSalinity(region: "Atlantic Ocean", days: 30)`
4. **Reflect**: Salinity around 35.5 PSU with minor fluctuations
5. **Present**: Display using DataTrendCard with salinity data

**Expected Output:**
- DataTrendCard showing salinity trends
- Min/Avg/Max values in PSU

## Scenario 3: Wave Measurements

**User Query:** "Where were the highest waves measured?"

**Agent Steps:**
1. **Perceive**: User wants to compare wave heights across regions
2. **Plan**: Call getWaveData to get measurements from multiple locations
3. **Act**: Call `getWaveData(count: 10)`
4. **Reflect**: Identify regions with highest wave heights
5. **Present**: Display multiple WaveInfoCards, sorted by height

**Expected Output:**
- Multiple WaveInfoCard widgets showing:
  - Region name
  - Wave height (in meters)
  - Wave period (in seconds)
  - Wave direction (N, NE, E, etc.)

## Scenario 4: Current Conditions

**User Query:** "What are the current conditions in the Mediterranean?"

**Agent Steps:**
1. **Perceive**: User wants comprehensive current data for Mediterranean
2. **Plan**: Call getCurrentConditions for Mediterranean region
3. **Act**: Call `getCurrentConditions(region: "Mediterranean Sea")`
4. **Reflect**: Get temperature, salinity, wave height, and wind speed
5. **Present**: Display multiple cards (Temperature, Salinity, Wave)

**Expected Output:**
- OceanTemperatureCard (~20°C)
- SalinityCard (~38 PSU - high salinity)
- WaveInfoCard with current wave data

## Agent Log Examples

### Example Log for Temperature Query:

```
[Perceive] User asked: "What is the ocean temperature in the North Sea?"
[Plan] Need to retrieve temperature data for North Sea region
[Act] Calling getOceanTemperature with region="North Sea", days=30
[Reflect] Data retrieved: 30 data points, average temperature 12.5°C
[Present] Creating OceanTemperatureCard and DataTrendCard widgets
```

### Example Log for Salinity Query:

```
[Perceive] User asked: "Show me salinity trends in the Atlantic Ocean"
[Plan] Need salinity time series data for Atlantic Ocean
[Act] Calling getOceanSalinity with region="Atlantic Ocean", days=30
[Reflect] Salinity values range from 35.1 to 35.9 PSU
[Present] Creating DataTrendCard with salinity statistics
```

## Testing the App

### Quick Test Flow:

1. **Launch the app**
2. **Check Agent Log panel** is visible at top
3. **Ask a question**: "What is the ocean temperature in the North Sea?"
4. **Watch Agent Log** fill with steps
5. **See visualization** appear in chat
6. **Try Stop button** during processing (if you're quick!)
7. **Toggle Agent Log** visibility with eye icon
8. **Clear Agent Log** with Clear button
9. **Ask follow-up**: "What about the Atlantic Ocean?"

### Expected Behavior:

- ✅ Agent log shows all 5 steps (Perceive → Plan → Act → Reflect → Present)
- ✅ Custom ocean widgets appear with proper styling
- ✅ Data values are realistic for each region
- ✅ Stop button appears during processing
- ✅ No errors in console

## Mock Data Details

### Temperature Ranges by Region:
- North Sea: ~12.5°C
- Atlantic Ocean: ~18.0°C
- Pacific Ocean: ~22.0°C
- Mediterranean Sea: ~20.0°C
- Baltic Sea: ~10.0°C

### Salinity Ranges by Region:
- North Sea: ~34.5 PSU
- Atlantic Ocean: ~35.5 PSU
- Pacific Ocean: ~34.8 PSU
- Mediterranean Sea: ~38.0 PSU (high!)
- Baltic Sea: ~7.5 PSU (brackish water)

### Wave Data:
- Heights: 1.0m to 7.0m
- Periods: 6s to 12s
- Directions: N, NE, E, SE, S, SW, W, NW

## UI Features to Demonstrate

1. **Agent Activity Log Panel**
   - Color-coded steps (purple, blue, orange, green, indigo)
   - Icons for each step type
   - Timestamps
   - Clear functionality

2. **Custom Ocean Widgets**
   - OceanTemperatureCard with thermometer icon
   - WaveInfoCard with wave metrics
   - SalinityCard with water drop icon
   - DataTrendCard with min/avg/max stats

3. **Interactive Elements**
   - Text input for queries
   - Send button
   - Stop button (during processing)
   - Agent log toggle (eye icon)
   - Agent log clear button

4. **Loading States**
   - Circular progress indicator
   - Stop button appears
   - Agent log updates in real-time

## Common Issues to Check

### If widgets don't appear:
- Check that catalog items are properly registered
- Verify PropertySchema types match widget properties
- Check console for GenUI errors

### If agent log is empty:
- Verify AgentLogService is injected in ChatViewModel
- Check that logging calls are made in the flow
- Toggle agent log visibility

### If tools aren't called:
- Check Firebase AI is properly configured
- Verify tools are added to additionalTools in genui_service.dart
- Check system prompt mentions the tools

### If data seems wrong:
- OceanDataService uses mock data - values are realistic but not real
- Each region has specific base temperatures and salinities
- Wave data is randomly distributed across regions
