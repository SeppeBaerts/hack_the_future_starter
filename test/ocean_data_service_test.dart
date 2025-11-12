import 'package:flutter_test/flutter_test.dart';
import 'package:hack_the_future_starter/features/chat/services/ocean_data_service.dart';

void main() {
  group('OceanDataService', () {
    test('should return mock data when mcpClient is null', () async {
      final service = OceanDataService();
      
      final temperatureData = await service.getTemperatureData('North Sea', days: 7);
      
      expect(temperatureData, isNotEmpty);
      expect(temperatureData.length, 7);
      expect(temperatureData.first.value, isA<double>());
      expect(temperatureData.first.timestamp, isA<DateTime>());
    });

    test('should return mock salinity data when mcpClient is null', () async {
      final service = OceanDataService();
      
      final salinityData = await service.getSalinityData('Atlantic Ocean', days: 5);
      
      expect(salinityData, isNotEmpty);
      expect(salinityData.length, 5);
      expect(salinityData.first.value, isA<double>());
    });

    test('should return mock wave data when mcpClient is null', () async {
      final service = OceanDataService();
      
      final waveData = await service.getWaveData(count: 10);
      
      expect(waveData, isNotEmpty);
      expect(waveData.length, 10);
      expect(waveData.first.height, isA<double>());
      expect(waveData.first.region.name, isA<String>());
    });

    test('should return current conditions', () {
      final service = OceanDataService();
      
      final conditions = service.getCurrentConditions('North Sea');
      
      expect(conditions, isNotNull);
      expect(conditions['region'], 'North Sea');
      expect(conditions['temperature'], isA<double>());
      expect(conditions['salinity'], isA<double>());
      expect(conditions['wave_height'], isA<double>());
      expect(conditions['wind_speed'], isA<double>());
    });

    test('should handle different region names', () async {
      final service = OceanDataService();
      
      final northSeaData = await service.getTemperatureData('North Sea');
      final atlanticData = await service.getTemperatureData('Atlantic Ocean');
      
      // Different regions should have different base temperatures
      expect(northSeaData.first.value, isNot(equals(atlanticData.first.value)));
    });
  });
}
