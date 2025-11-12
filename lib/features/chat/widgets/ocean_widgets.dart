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

  Color _getTemperatureColor(double temp) {
    if (temp < 5) return Colors.blue.shade700;
    if (temp < 15) return Colors.cyan.shade600;
    if (temp < 25) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final tempColor = _getTemperatureColor(temperature);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tempColor.withOpacity(0.1),
              tempColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: tempColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.thermostat,
                      color: tempColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          'Ocean Temperature',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      '${temperature.toStringAsFixed(1)}$unit',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: tempColor,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tempColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getTemperatureLabel(temperature),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: tempColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTemperatureLabel(double temp) {
    if (temp < 5) return 'Very Cold';
    if (temp < 15) return 'Cold';
    if (temp < 25) return 'Moderate';
    return 'Warm';
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

  Color _getWaveColor(double height) {
    if (height < 1) return Colors.cyan.shade400;
    if (height < 3) return Colors.blue.shade500;
    if (height < 5) return Colors.indigo.shade600;
    return Colors.deepPurple.shade700;
  }

  String _getWaveSeverity(double height) {
    if (height < 1) return 'Calm';
    if (height < 3) return 'Moderate';
    if (height < 5) return 'Rough';
    return 'Very Rough';
  }

  @override
  Widget build(BuildContext context) {
    final waveColor = _getWaveColor(height);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              waveColor.withOpacity(0.15),
              waveColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: waveColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.water,
                      color: waveColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          _getWaveSeverity(height),
                          style: TextStyle(
                            fontSize: 13,
                            color: waveColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('Height', '${height.toStringAsFixed(1)}m', waveColor),
                  _buildMetric('Period', '${period.toStringAsFixed(1)}s', waveColor),
                  _buildMetric('Direction', direction, waveColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

  Color _getSalinityColor(double salinity) {
    // Typical ocean salinity is 33-37 PSU
    if (salinity < 33) return Colors.lightBlue.shade600;
    if (salinity < 35.5) return Colors.teal.shade600;
    return Colors.cyan.shade700;
  }

  String _getSalinityLevel(double salinity) {
    if (salinity < 33) return 'Low Salinity';
    if (salinity < 35.5) return 'Normal Salinity';
    return 'High Salinity';
  }

  @override
  Widget build(BuildContext context) {
    final salinityColor = _getSalinityColor(salinity);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              salinityColor.withOpacity(0.15),
              salinityColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: salinityColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.opacity,
                      color: salinityColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          _getSalinityLevel(salinity),
                          style: TextStyle(
                            fontSize: 13,
                            color: salinityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      '${salinity.toStringAsFixed(1)} PSU',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: salinityColor,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Practical Salinity Units',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No data available for $title',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    final values = dataPoints.map((p) => p['value'] as double).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final avgValue = values.reduce((a, b) => a + b) / values.length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.12),
              color.withOpacity(0.04),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.show_chart,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          '${dataPoints.length} data points',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Simple visualization with bars
              _buildSimpleChart(values, minValue, maxValue, color),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Min', minValue, unit, color),
                  _buildStat('Avg', avgValue, unit, color),
                  _buildStat('Max', maxValue, unit, color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleChart(List<double> values, double min, double max, Color color) {
    final range = max - min;
    if (range == 0) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        child: Text(
          'All values are the same',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      );
    }

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.take(30).map((value) {
          final normalizedHeight = ((value - min) / range).clamp(0.1, 1.0);
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.4),
                  ],
                ),
              ),
              height: 70 * normalizedHeight,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStat(String label, double value, String unit, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${value.toStringAsFixed(1)}$unit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

/// A custom gauge widget for displaying ocean metrics with a circular gauge
class OceanGaugeCard extends StatelessWidget {
  const OceanGaugeCard({
    required this.title,
    required this.value,
    required this.maxValue,
    required this.unit,
    this.minValue = 0,
    this.color,
    super.key,
  });

  final String title;
  final double value;
  final double minValue;
  final double maxValue;
  final String unit;
  final Color? color;

  Color _getGaugeColor() {
    if (color != null) return color!;
    
    // Default color based on percentage
    final percentage = (value - minValue) / (maxValue - minValue);
    if (percentage < 0.3) return Colors.green.shade600;
    if (percentage < 0.7) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final gaugeColor = _getGaugeColor();
    final percentage = ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gaugeColor.withOpacity(0.1),
              gaugeColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              // Circular gauge
              SizedBox(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: _GaugePainter(
                    percentage: percentage,
                    color: gaugeColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: gaugeColor,
                          ),
                        ),
                        Text(
                          unit,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRangeLabel('Min', minValue, unit, Colors.grey.shade600),
                  _buildRangeLabel('Max', maxValue, unit, Colors.grey.shade600),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRangeLabel(String label, double value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}$unit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for circular gauge
class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.percentage, required this.color});

  final double percentage;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Foreground arc (progress)
    final foregroundPaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    const startAngle = -3.14159 / 2; // Start from top
    final sweepAngle = 2 * 3.14159 * percentage;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
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
    'minValue': S.number(
      description: 'Minimum value for the gauge range',
    ),
    'maxValue': S.number(
      description: 'Maximum value for the gauge range',
    ),
    'unit': S.string(
      description: 'Unit of measurement',
    ),
  },
  required: ['title', 'value', 'maxValue', 'unit'],
);

extension type _OceanGaugeData.fromMap(Map<String, Object?> _json) {
  factory _OceanGaugeData({
    required String title,
    required double value,
    double? minValue,
    required double maxValue,
    required String unit,
  }) =>
      _OceanGaugeData.fromMap({
        'title': title,
        'value': value,
        if (minValue != null) 'minValue': minValue,
        'maxValue': maxValue,
        'unit': unit,
      });

  String get title => _json['title'] as String;
  double get value => (_json['value'] as num).toDouble();
  double get minValue => (_json['minValue'] as num?)?.toDouble() ?? 0;
  double get maxValue => (_json['maxValue'] as num).toDouble();
  String get unit => _json['unit'] as String;
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
      minValue: data.minValue,
      maxValue: data.maxValue,
      unit: data.unit,
    );
  },
);

/// A custom heatmap widget for displaying ocean temperature/salinity data
class OceanHeatmapCard extends StatelessWidget {
  const OceanHeatmapCard({
    required this.title,
    required this.gridData,
    required this.unit,
    super.key,
  });

  final String title;
  final List<Map<String, dynamic>> gridData;
  final String unit;

  Color _getHeatmapColor(double value, double min, double max) {
    final range = max - min;
    if (range == 0) return Colors.blue.shade300;
    
    final normalized = (value - min) / range;
    
    if (normalized < 0.2) return Colors.blue.shade700;
    if (normalized < 0.4) return Colors.cyan.shade500;
    if (normalized < 0.6) return Colors.yellow.shade600;
    if (normalized < 0.8) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    if (gridData.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('No data available'),
        ),
      );
    }

    // Extract values and calculate min/max
    final values = gridData
        .map((d) => (d['value'] as num).toDouble())
        .toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.grid_on,
                    color: Colors.deepPurple.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        'Spatial distribution',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Heatmap grid - show a simple grid representation
            _buildHeatmapGrid(gridData, minValue, maxValue),
            const SizedBox(height: 12),
            // Legend
            _buildLegend(minValue, maxValue, unit),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapGrid(List<Map<String, dynamic>> data, double min, double max) {
    // Create a simple grid layout (4x4 or based on data length)
    final gridSize = (data.length.clamp(4, 16)).toInt();
    final cellsPerRow = 4;
    final rows = (gridSize / cellsPerRow).ceil();

    return Column(
      children: List.generate(rows.clamp(1, 4), (rowIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(cellsPerRow, (colIndex) {
              final dataIndex = rowIndex * cellsPerRow + colIndex;
              if (dataIndex >= data.length) {
                return Expanded(
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(2),
                  ),
                );
              }
              
              final cellData = data[dataIndex];
              final value = (cellData['value'] as num).toDouble();
              final region = cellData['region'] as String? ?? '';
              
              return Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(value, min, max),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (region.isNotEmpty)
                        Text(
                          region.length > 4 ? region.substring(0, 4) : region,
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildLegend(double min, double max, String unit) {
    return Row(
      children: [
        Text(
          'Low',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700,
                  Colors.cyan.shade500,
                  Colors.yellow.shade600,
                  Colors.orange.shade600,
                  Colors.red.shade600,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'High',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 12),
        Text(
          '${min.toStringAsFixed(1)} - ${max.toStringAsFixed(1)}$unit',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

// Schema for OceanHeatmapCard
final _oceanHeatmapSchema = S.object(
  properties: {
    'title': S.string(
      description: 'Title of the heatmap',
    ),
    'gridData': S.list(
      description: 'Grid data points with region and value',
      items: S.object(
        properties: {
          'region': S.string(
            description: 'Region identifier or name',
          ),
          'value': S.number(
            description: 'The numeric value for this grid cell',
          ),
        },
        required: ['value'],
      ),
    ),
    'unit': S.string(
      description: 'Unit of measurement',
    ),
  },
  required: ['title', 'gridData', 'unit'],
);

extension type _OceanHeatmapData.fromMap(Map<String, Object?> _json) {
  factory _OceanHeatmapData({
    required String title,
    required List<Map<String, dynamic>> gridData,
    required String unit,
  }) =>
      _OceanHeatmapData.fromMap({
        'title': title,
        'gridData': gridData,
        'unit': unit,
      });

  String get title => _json['title'] as String;
  List<Map<String, dynamic>> get gridData =>
      (_json['gridData'] as List).cast<Map<String, dynamic>>();
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
      gridData: data.gridData,
      unit: data.unit,
    );
  },
);
