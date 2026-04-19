import 'package:flutter/material.dart';
import '../services/group_storage_service.dart';
import '../sections/data_usage_section.dart';

class UsageSection extends StatefulWidget {
  const UsageSection({super.key});

  @override
  State<UsageSection> createState() => _UsageSectionState();
}

class _UsageSectionState extends State<UsageSection> {
  Map<String, double> _usageMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsage();
  }

  Future<void> _loadUsage() async {
    setState(() => _loading = true);
    final usage = await GroupStorageService.loadUsageMap();
    setState(() {
      _usageMap = usage;
      _loading = false;
    });
  }

  Future<void> _clearUsage() async {
    await GroupStorageService.clearAllUsage();
    setState(() {
      _usageMap.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: DataUsageSection(usageMap: _usageMap, planLimitMB: 20000.0),
        ),
        ElevatedButton(
          onPressed: _clearUsage,
          child: const Text('Clear All Usage'),
        ),
      ],
    );
  }
}
