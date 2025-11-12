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

/// A custom widget for displaying ocean metrics with a gauge meter
class OceanGaugeCard extends StatelessWidget {
  const OceanGaugeCard({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    this.color = Colors.blue,
    this.dangerThreshold,
    super.key,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final String unit;
  final Color color;
  final double? dangerThreshold;

  @override
  Widget build(BuildContext context) {
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final isDanger = dangerThreshold != null && value >= dangerThreshold!;
    final displayColor = isDanger ? Colors.red : color;

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
            // Gauge visualization
            SizedBox(
              height: 120,
              child: CustomPaint(
                painter: _GaugePainter(
                  percentage: percentage,
                  color: displayColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${value.toStringAsFixed(1)}$unit',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: displayColor,
                        ),
                      ),
                      if (isDanger)
                        const Text(
                          'Warning',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${min.toStringAsFixed(0)}$unit',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${max.toStringAsFixed(0)}$unit',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.percentage,
    required this.color,
  });

  final double percentage;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.75 * 3.14159, // Start at 135 degrees
      1.5 * 3.14159, // Sweep 270 degrees
      false,
      backgroundPaint,
    );

    // Foreground arc (filled)
    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.75 * 3.14159,
      1.5 * 3.14159 * percentage,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}

// Schema for OceanGaugeCard
final _oceanGaugeSchema = S.object(
  properties: {
    'title': S.string(
      description: 'Title of the gauge metric',
    ),
    'value': S.number(
      description: 'Current value',
    ),
    'min': S.number(
      description: 'Minimum value on the gauge',
    ),
    'max': S.number(
      description: 'Maximum value on the gauge',
    ),
    'unit': S.string(
      description: 'Unit of measurement',
    ),
    'dangerThreshold': S.number(
      description: 'Optional threshold above which the gauge shows danger (red)',
    ),
  },
  required: ['title', 'value', 'min', 'max', 'unit'],
);

extension type _OceanGaugeData.fromMap(Map<String, Object?> _json) {
  factory _OceanGaugeData({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    double? dangerThreshold,
  }) =>
      _OceanGaugeData.fromMap({
        'title': title,
        'value': value,
        'min': min,
        'max': max,
        'unit': unit,
        if (dangerThreshold != null) 'dangerThreshold': dangerThreshold,
      });

  String get title => _json['title'] as String;
  double get value => (_json['value'] as num).toDouble();
  double get min => (_json['min'] as num).toDouble();
  double get max => (_json['max'] as num).toDouble();
  String get unit => _json['unit'] as String;
  double? get dangerThreshold => (_json['dangerThreshold'] as num?)?.toDouble();
}

final oceanGaugeCardItem = CatalogItem(
  name: 'OceanGaugeCard',
  dataSchema: _oceanGaugeSchema,
  widgetBuilder: (context) {
    final data = _OceanGaugeData.fromMap(
      context.data as Map<String, Object?>,
    );
    return OceanGaugeCard(
      title: data.title,
      value: data.value,
      min: data.min,
      max: data.max,
      unit: data.unit,
      dangerThreshold: data.dangerThreshold,
    );
  },
);

/// A custom widget for displaying ocean data as a heatmap
class OceanHeatmapCard extends StatelessWidget {
  const OceanHeatmapCard({
    required this.title,
    required this.regions,
    required this.unit,
    super.key,
  });

  final String title;
  final List<Map<String, dynamic>> regions;
  final String unit;

  @override
  Widget build(BuildContext context) {
    if (regions.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No data available for $title'),
        ),
      );
    }

    // Calculate min/max for color scaling
    final values = regions.map((r) => r['value'] as double).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);

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
            ...regions.map((region) {
              final name = region['name'] as String;
              final value = region['value'] as double;
              final normalized = (value - minValue) / (maxValue - minValue);
              final color = Color.lerp(
                Colors.blue.shade100,
                Colors.red.shade700,
                normalized,
              )!;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${value.toStringAsFixed(1)}$unit',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: normalized > 0.5 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: ${minValue.toStringAsFixed(1)}$unit',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  'Max: ${maxValue.toStringAsFixed(1)}$unit',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Schema for OceanHeatmapCard
final _oceanHeatmapSchema = S.object(
  properties: {
    'title': S.string(
      description: 'Title of the heatmap',
    ),
    'regions': S.list(
      description: 'List of regions with their values',
      items: S.object(
        properties: {
          'name': S.string(
            description: 'Name of the region',
          ),
          'value': S.number(
            description: 'Value for this region',
          ),
        },
        required: ['name', 'value'],
      ),
    ),
    'unit': S.string(
      description: 'Unit of measurement',
    ),
  },
  required: ['title', 'regions', 'unit'],
);

extension type _OceanHeatmapData.fromMap(Map<String, Object?> _json) {
  factory _OceanHeatmapData({
    required String title,
    required List<Map<String, Object?>> regions,
    required String unit,
  }) =>
      _OceanHeatmapData.fromMap({
        'title': title,
        'regions': regions,
        'unit': unit,
      });

  String get title => _json['title'] as String;
  List<Map<String, dynamic>> get regions =>
      (_json['regions'] as List).cast<Map<String, dynamic>>();
  String get unit => _json['unit'] as String;
}

final oceanHeatmapCardItem = CatalogItem(
  name: 'OceanHeatmapCard',
  dataSchema: _oceanHeatmapSchema,
  widgetBuilder: (context) {
    final data = _OceanHeatmapData.fromMap(
      context.data as Map<String, Object?>,
    );
    return OceanHeatmapCard(
      title: data.title,
      regions: data.regions,
      unit: data.unit,
    );
  },
);
