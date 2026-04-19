import 'dart:collection';
import 'package:collection/collection.dart';
import 'data_usage_service.dart';

class Slot {
  final String userId;
  final String userName;
  final DateTime start;
  final DateTime end;
  Slot({
    required this.userId,
    required this.userName,
    required this.start,
    required this.end,
  });
}

class UsageAggregationService {
  // Returns: { userId: totalMB }
  static Future<Map<String, double>> usagePerUserMB(List<Slot> slots) async {
    final Map<String, double> totals = HashMap();
    for (final s in slots) {
      final mb = await DataUsageService.getMobileUsageMB(s.start, s.end);
      totals[s.userId] = (totals[s.userId] ?? 0) + mb;
    }
    return totals;
  }

  static double totalGroupMB(Map<String, double> perUser) =>
      perUser.values.fold(0.0, (a, b) => a + b);

  // Convenience for UI: combine by userName
  static Future<Map<String, double>> usagePerUserNameMB(
    List<Slot> slots,
  ) async {
    final grouped = groupBy(slots, (Slot s) => s.userName);
    final Map<String, double> out = {};
    for (final entry in grouped.entries) {
      double sum = 0;
      for (final s in entry.value) {
        sum += await DataUsageService.getMobileUsageMB(s.start, s.end);
      }
      out[entry.key] = sum;
    }
    return out;
  }
}
