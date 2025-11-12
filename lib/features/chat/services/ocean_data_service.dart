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
  // Mock temperature data for various regions
  List<OceanDataPoint> getTemperatureData(String region, {int days = 30}) {
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

  // Mock salinity data
  List<OceanDataPoint> getSalinityData(String region, {int days = 30}) {
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

  // Mock wave data
  List<WaveData> getWaveData({int count = 10}) {
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
}
