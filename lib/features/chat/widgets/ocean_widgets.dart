import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

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
final oceanTemperatureCardItem = CatalogItem<OceanTemperatureCard>(
  type: 'OceanTemperatureCard',
  description: 'Displays ocean temperature for a region with a thermometer icon',
  builder: (context) => const OceanTemperatureCard(
    region: 'Unknown',
    temperature: 0.0,
  ),
  propertiesSchema: {
    'region': PropertySchema<String>(
      description: 'Name of the ocean region',
      defaultValue: 'Unknown Region',
    ),
    'temperature': PropertySchema<double>(
      description: 'Temperature value in degrees',
      defaultValue: 0.0,
    ),
    'unit': PropertySchema<String>(
      description: 'Temperature unit (default: °C)',
      defaultValue: '°C',
    ),
  },
);

final waveInfoCardItem = CatalogItem<WaveInfoCard>(
  type: 'WaveInfoCard',
  description: 'Displays wave information including height, period, and direction',
  builder: (context) => const WaveInfoCard(
    region: 'Unknown',
    height: 0.0,
    period: 0.0,
    direction: 'N',
  ),
  propertiesSchema: {
    'region': PropertySchema<String>(
      description: 'Name of the ocean region',
      defaultValue: 'Unknown Region',
    ),
    'height': PropertySchema<double>(
      description: 'Wave height in meters',
      defaultValue: 0.0,
    ),
    'period': PropertySchema<double>(
      description: 'Wave period in seconds',
      defaultValue: 0.0,
    ),
    'direction': PropertySchema<String>(
      description: 'Wave direction (N, NE, E, SE, S, SW, W, NW)',
      defaultValue: 'N',
    ),
  },
);

final salinityCardItem = CatalogItem<SalinityCard>(
  type: 'SalinityCard',
  description: 'Displays ocean salinity in PSU (Practical Salinity Units)',
  builder: (context) => const SalinityCard(
    region: 'Unknown',
    salinity: 0.0,
  ),
  propertiesSchema: {
    'region': PropertySchema<String>(
      description: 'Name of the ocean region',
      defaultValue: 'Unknown Region',
    ),
    'salinity': PropertySchema<double>(
      description: 'Salinity value in PSU',
      defaultValue: 0.0,
    ),
  },
);

final dataTrendCardItem = CatalogItem<DataTrendCard>(
  type: 'DataTrendCard',
  description: 'Displays trend statistics (min, avg, max) for a dataset',
  builder: (context) => const DataTrendCard(
    title: 'Data Trend',
    dataPoints: [],
    unit: '',
  ),
  propertiesSchema: {
    'title': PropertySchema<String>(
      description: 'Title of the data trend',
      defaultValue: 'Data Trend',
    ),
    'dataPoints': PropertySchema<List<Map<String, dynamic>>>(
      description: 'List of data points with timestamp and value',
      defaultValue: [],
    ),
    'unit': PropertySchema<String>(
      description: 'Unit of measurement',
      defaultValue: '',
    ),
    'color': PropertySchema<Color>(
      description: 'Color for the statistics',
      defaultValue: Colors.blue,
    ),
  },
);
