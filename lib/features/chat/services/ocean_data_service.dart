class OceanDataPoint {
  const OceanDataPoint({
    required this.timestamp,
    required this.value,
  });

  final DateTime timestamp;
  final double value;

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'value': value,
      };
}

class OceanRegion {
  const OceanRegion({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
      };
}

class WaveData {
  const WaveData({
    required this.region,
    required this.height,
    required this.period,
    required this.direction,
    required this.timestamp,
  });

  final OceanRegion region;
  final double height;
  final double period;
  final String direction;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'region': region.toJson(),
        'height': height,
        'period': period,
        'direction': direction,
        'timestamp': timestamp.toIso8601String(),
      };
}

class OceanDataService {
  OceanDataService({this.mcpClient});

  final dynamic mcpClient; // McpClientService, optional for non-intrusive integration

  // Get temperature data - tries MCP first, falls back to mock
  Future<List<OceanDataPoint>> getTemperatureData(
    String region, {
    int days = 30,
  }) async {
    if (mcpClient != null) {
      try {
        final endDate = DateTime.now();
        final startDate = endDate.subtract(Duration(days: days));
        
        final data = await mcpClient.getTemperatureTimeSeries(
          region: region,
          startDate: _formatDate(startDate),
          endDate: _formatDate(endDate),
        );

        // Convert MCP response to OceanDataPoint format
        return data.map<OceanDataPoint>((item) {
          return OceanDataPoint(
            timestamp: DateTime.parse(item['date'] as String),
            value: (item['avg_c'] as num).toDouble(),
          );
        }).toList();
      } catch (e) {
        // Log error and fall back to mock data
        print('Failed to fetch MCP temperature data: $e. Using mock data.');
      }
    }

    // Fall back to mock data
    return _getMockTemperatureData(region, days: days);
  }

  // Mock temperature data for fallback
  List<OceanDataPoint> _getMockTemperatureData(String region, {int days = 30}) {
    final now = DateTime.now();
    final baseTemp = _getBaseTemperature(region);
    
    return List.generate(days, (index) {
      final date = now.subtract(Duration(days: days - index));
      final variation = (index % 7) * 0.5 - 1.5; // Simulate weekly variation
      return OceanDataPoint(
        timestamp: date,
        value: baseTemp + variation,
      );
    });
  }

  // Get salinity data - tries MCP first, falls back to mock
  Future<List<OceanDataPoint>> getSalinityData(
    String region, {
    int days = 30,
  }) async {
    if (mcpClient != null) {
      try {
        final endDate = DateTime.now();
        final startDate = endDate.subtract(Duration(days: days));
        
        final data = await mcpClient.getSalinityTrends(
          region: region,
          startDate: _formatDate(startDate),
          endDate: _formatDate(endDate),
        );

        // Convert MCP response to OceanDataPoint format
        return data.map<OceanDataPoint>((item) {
          return OceanDataPoint(
            timestamp: DateTime.parse(item['date'] as String),
            value: (item['avg_psu'] as num).toDouble(),
          );
        }).toList();
      } catch (e) {
        // Log error and fall back to mock data
        print('Failed to fetch MCP salinity data: $e. Using mock data.');
      }
    }

    // Fall back to mock data
    return _getMockSalinityData(region, days: days);
  }

  // Mock salinity data for fallback
  List<OceanDataPoint> _getMockSalinityData(String region, {int days = 30}) {
    final now = DateTime.now();
    final baseSalinity = _getBaseSalinity(region);
    
    return List.generate(days, (index) {
      final date = now.subtract(Duration(days: days - index));
      final variation = (index % 5) * 0.2 - 0.4; // Simulate variation
      return OceanDataPoint(
        timestamp: date,
        value: baseSalinity + variation,
      );
    });
  }

  // Get wave data - tries MCP first, falls back to mock
  Future<List<WaveData>> getWaveData({int count = 10}) async {
    if (mcpClient != null) {
      try {
        final endDate = DateTime.now();
        final startDate = endDate.subtract(const Duration(days: 30));
        
        // Try to get wave data from different regions
        final regions = ['Noordzee', 'Atlantische Oceaan', 'Stille Oceaan'];
        final List<WaveData> allWaves = [];

        for (final region in regions) {
          try {
            final data = await mcpClient.getHighestWaves(
              region: region,
              startDate: _formatDate(startDate),
              endDate: _formatDate(endDate),
            );

            // Convert MCP response to WaveData format
            for (final item in data) {
              allWaves.add(WaveData(
                region: OceanRegion(
                  name: item['region'] as String,
                  latitude: (item['lat'] as num).toDouble(),
                  longitude: (item['lon'] as num).toDouble(),
                ),
                height: (item['wave_height_m'] as num).toDouble(),
                period: 8.0, // Default period as not provided by MCP
                direction: 'N', // Default direction as not provided by MCP
                timestamp: DateTime.parse(item['timestamp'] as String),
              ));
            }
          } catch (e) {
            // Continue to next region
            continue;
          }
        }

        if (allWaves.isNotEmpty) {
          // Sort by wave height descending and return top count
          allWaves.sort((a, b) => b.height.compareTo(a.height));
          return allWaves.take(count).toList();
        }
      } catch (e) {
        // Log error and fall back to mock data
        print('Failed to fetch MCP wave data: $e. Using mock data.');
      }
    }

    // Fall back to mock data
    return _getMockWaveData(count: count);
  }

  // Mock wave data for fallback
  List<WaveData> _getMockWaveData({int count = 10}) {
    final regions = [
      const OceanRegion(name: 'North Sea', latitude: 56.0, longitude: 3.0),
      const OceanRegion(name: 'Atlantic Ocean (North)', latitude: 45.0, longitude: -30.0),
      const OceanRegion(name: 'Pacific Ocean', latitude: 20.0, longitude: -150.0),
      const OceanRegion(name: 'Mediterranean Sea', latitude: 35.0, longitude: 18.0),
      const OceanRegion(name: 'Baltic Sea', latitude: 58.0, longitude: 20.0),
    ];

    final now = DateTime.now();
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];

    return List.generate(count, (index) {
      final region = regions[index % regions.length];
      return WaveData(
        region: region,
        height: 1.0 + (index % 5) * 1.5, // 1.0 to 7.0 meters
        period: 6.0 + (index % 4) * 2.0, // 6 to 12 seconds
        direction: directions[index % directions.length],
        timestamp: now.subtract(Duration(hours: index * 2)),
      );
    });
  }

  double _getBaseTemperature(String region) {
    final regionLower = region.toLowerCase();
    if (regionLower.contains('north sea') || regionLower.contains('noordzee')) {
      return 12.5;
    } else if (regionLower.contains('atlantic')) {
      return 18.0;
    } else if (regionLower.contains('pacific')) {
      return 22.0;
    } else if (regionLower.contains('mediterranean')) {
      return 20.0;
    } else if (regionLower.contains('baltic')) {
      return 10.0;
    }
    return 15.0; // Default
  }

  double _getBaseSalinity(String region) {
    final regionLower = region.toLowerCase();
    if (regionLower.contains('north sea') || regionLower.contains('noordzee')) {
      return 34.5;
    } else if (regionLower.contains('atlantic')) {
      return 35.5;
    } else if (regionLower.contains('pacific')) {
      return 34.8;
    } else if (regionLower.contains('mediterranean')) {
      return 38.0;
    } else if (regionLower.contains('baltic')) {
      return 7.5; // Baltic is brackish
    }
    return 35.0; // Default
  }

  // Get current conditions for a region
  Map<String, dynamic> getCurrentConditions(String region) {
    final temp = _getBaseTemperature(region);
    final salinity = _getBaseSalinity(region);
    
    return {
      'region': region,
      'temperature': temp,
      'salinity': salinity,
      'wave_height': 2.5,
      'wind_speed': 15.0,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Helper to format dates as yyyy-mm-dd for MCP API
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
