import 'package:flutter/material.dart';
import '../sections/data_usage_section.dart';

class GroupUsageScreen extends StatelessWidget {
  final String groupName;
  final Map<String, double> usageMap; // userName → MB
  final double planLimitMB;

  const GroupUsageScreen({
    super.key,
    required this.groupName,
    required this.usageMap,
    required this.planLimitMB,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$groupName Usage')),
      body: DataUsageSection(usageMap: usageMap, planLimitMB: planLimitMB),
    );
  }
}
