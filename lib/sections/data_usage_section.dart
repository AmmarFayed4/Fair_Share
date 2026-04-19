import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DataUsageSection extends StatelessWidget {
  final Map<String, double> usageMap;
  final double planLimitMB;

  const DataUsageSection({
    super.key,
    required this.usageMap,
    required this.planLimitMB,
  });

  @override
  Widget build(BuildContext context) {
    final totalMB = usageMap.values.fold(0.0, (a, b) => a + b);

    final sections = usageMap.entries.map((e) {
      final perc = totalMB > 0 ? (e.value / totalMB) * 100 : 0.0;
      return PieChartSectionData(
        color: _colorFor(e.key),
        value: e.value,
        title: '${perc.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Usage Distribution (This Week)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                startDegreeOffset: 180,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Usage by User:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...usageMap.entries.map(
            (e) => _legendItem(e.key, _colorFor(e.key), e.value),
          ),
          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF063a60),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Total Group Data This Week',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${totalMB.toStringAsFixed(1)} MB / ${planLimitMB.toStringAsFixed(0)} MB',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: planLimitMB > 0
                        ? (totalMB / planLimitMB).clamp(0.0, 1.0)
                        : 0,
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _legendItem(String name, Color color, double usageMB) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            '${usageMB.toStringAsFixed(1)} MB',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static Color _colorFor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.pink,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.cyan,
    ];
    final idx = name.hashCode.abs() % colors.length;
    return colors[idx];
  }
}
