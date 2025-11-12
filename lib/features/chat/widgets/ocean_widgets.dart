import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// A custom widget for displaying ocean temperature information
class OceanTemperatureCard extends StatelessWidget {
  const OceanTemperatureCard({
    required this.region,
    required this.temperature,
    this.unit = '°C',
    super.key,
  });

  final String region;
  final double temperature;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.thermostat, color: Colors.blue, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    region,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${temperature.toStringAsFixed(1)}$unit',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom widget for displaying wave information
class WaveInfoCard extends StatelessWidget {
  const WaveInfoCard({
    required this.region,
    required this.height,
    required this.period,
    required this.direction,
    super.key,
  });

  final String region;
  final double height;
  final double period;
  final String direction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.water, color: Colors.cyan, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    region,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric('Height', '${height.toStringAsFixed(1)}m'),
                _buildMetric('Period', '${period.toStringAsFixed(1)}s'),
                _buildMetric('Direction', direction),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyan,
          ),
        ),
      ],
    );
  }
}

/// A custom widget for displaying salinity information
class SalinityCard extends StatelessWidget {
  const SalinityCard({
    required this.region,
    required this.salinity,
    super.key,
  });

  final String region;
  final double salinity;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.opacity, color: Colors.teal, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    region,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    '${salinity.toStringAsFixed(1)} PSU',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Salinity',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom widget for displaying a simple data trend
class DataTrendCard extends StatelessWidget {
  const DataTrendCard({
    required this.title,
    required this.dataPoints,
    required this.unit,
    this.color = Colors.blue,
    super.key,
  });

  final String title;
  final List<Map<String, dynamic>> dataPoints;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No data available for $title'),
        ),
      );
    }

    final values = dataPoints.map((p) => p['value'] as double).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final avgValue = values.reduce((a, b) => a + b) / values.length;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Min', minValue, unit, color),
                _buildStat('Avg', avgValue, unit, color),
                _buildStat('Max', maxValue, unit, color),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${dataPoints.length} data points over ${dataPoints.length} days',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, double value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}$unit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Catalog item definitions for GenUI

// Schema for OceanTemperatureCard
final _oceanTemperatureSchema = S.object(
  properties: {
    'region': S.string(
      description: 'Name of the ocean region',
    ),
    'temperature': S.number(
      description: 'Temperature value in degrees',
    ),
    'unit': S.string(
      description: 'Temperature unit (default: °C)',
    ),
  },
  required: ['region', 'temperature'],
);

extension type _OceanTemperatureData.fromMap(Map<String, Object?> _json) {
  factory _OceanTemperatureData({
    required String region,
    required double temperature,
    String? unit,
  }) =>
      _OceanTemperatureData.fromMap({
        'region': region,
        'temperature': temperature,
        if (unit != null) 'unit': unit,
      });

  String get region => _json['region'] as String;
  double get temperature => (_json['temperature'] as num).toDouble();
  String get unit => (_json['unit'] as String?) ?? '°C';
}

final oceanTemperatureCardItem = CatalogItem(
  name: 'OceanTemperatureCard',
  dataSchema: _oceanTemperatureSchema,
  widgetBuilder: (context) {
    final data = _OceanTemperatureData.fromMap(
      context.data as Map<String, Object?>,
    );
    return OceanTemperatureCard(
      region: data.region,
      temperature: data.temperature,
      unit: data.unit,
    );
  },
);

// Schema for WaveInfoCard
final _waveInfoSchema = S.object(
  properties: {
    'region': S.string(
      description: 'Name of the ocean region',
    ),
    'height': S.number(
      description: 'Wave height in meters',
    ),
    'period': S.number(
      description: 'Wave period in seconds',
    ),
    'direction': S.string(
      description: 'Wave direction (N, NE, E, SE, S, SW, W, NW)',
    ),
  },
  required: ['region', 'height', 'period', 'direction'],
);

extension type _WaveInfoData.fromMap(Map<String, Object?> _json) {
  factory _WaveInfoData({
    required String region,
    required double height,
    required double period,
    required String direction,
  }) =>
      _WaveInfoData.fromMap({
        'region': region,
        'height': height,
        'period': period,
        'direction': direction,
      });

  String get region => _json['region'] as String;
  double get height => (_json['height'] as num).toDouble();
  double get period => (_json['period'] as num).toDouble();
  String get direction => _json['direction'] as String;
}

final waveInfoCardItem = CatalogItem(
  name: 'WaveInfoCard',
  dataSchema: _waveInfoSchema,
  widgetBuilder: (context) {
    final data = _WaveInfoData.fromMap(
      context.data as Map<String, Object?>,
    );
    return WaveInfoCard(
      region: data.region,
      height: data.height,
      period: data.period,
      direction: data.direction,
    );
  },
);

// Schema for SalinityCard
final _salinitySchema = S.object(
  properties: {
    'region': S.string(
      description: 'Name of the ocean region',
    ),
    'salinity': S.number(
      description: 'Salinity value in PSU',
    ),
  },
  required: ['region', 'salinity'],
);

extension type _SalinityData.fromMap(Map<String, Object?> _json) {
  factory _SalinityData({
    required String region,
    required double salinity,
  }) =>
      _SalinityData.fromMap({
        'region': region,
        'salinity': salinity,
      });

  String get region => _json['region'] as String;
  double get salinity => (_json['salinity'] as num).toDouble();
}

final salinityCardItem = CatalogItem(
  name: 'SalinityCard',
  dataSchema: _salinitySchema,
  widgetBuilder: (context) {
    final data = _SalinityData.fromMap(
      context.data as Map<String, Object?>,
    );
    return SalinityCard(
      region: data.region,
      salinity: data.salinity,
    );
  },
);

// Schema for DataTrendCard
final _dataTrendSchema = S.object(
  properties: {
    'title': S.string(
      description: 'Title of the data trend',
    ),
    'dataPoints': S.list(
      description: 'List of data points with timestamp and value',
      items: S.object(
        properties: {
          'timestamp': S.string(
            description: 'ISO 8601 timestamp for the data point',
          ),
          'value': S.number(
            description: 'The numeric value for this data point',
          ),
        },
        required: ['timestamp', 'value'],
      ),
    ),
    'unit': S.string(
      description: 'Unit of measurement',
    ),
  },
  required: ['title', 'dataPoints', 'unit'],
);

extension type _DataTrendData.fromMap(Map<String, Object?> _json) {
  factory _DataTrendData({
    required String title,
    required List<Map<String, Object?>> dataPoints,
    required String unit,
  }) =>
      _DataTrendData.fromMap({
        'title': title,
        'dataPoints': dataPoints,
        'unit': unit,
      });

  String get title => _json['title'] as String;
  List<Map<String, dynamic>> get dataPoints =>
      (_json['dataPoints'] as List).cast<Map<String, dynamic>>();
  String get unit => _json['unit'] as String;
}

final dataTrendCardItem = CatalogItem(
  name: 'DataTrendCard',
  dataSchema: _dataTrendSchema,
  widgetBuilder: (context) {
    final data = _DataTrendData.fromMap(
      context.data as Map<String, Object?>,
    );
    return DataTrendCard(
      title: data.title,
      dataPoints: data.dataPoints,
      unit: data.unit,
    );
  },
);
