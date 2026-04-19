import 'package:fair_share/services/usage_aggregation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'group_storage_service.dart';

class WeeklyUsageService {
  static const _lastResetKey = 'lastWeeklyReset';

  /// Check if we need to reset usage (Friday 11:00) and do it if needed
  static Future<void> checkAndResetIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetMillis = prefs.getInt(_lastResetKey);
    final now = DateTime.now();

    final fridayReset = _getThisWeeksFridayReset(now);

    if (now.isAfter(fridayReset) &&
        (lastResetMillis == null ||
            DateTime.fromMillisecondsSinceEpoch(
              lastResetMillis,
            ).isBefore(fridayReset))) {
      await _clearAllUsage();
      await prefs.setInt(_lastResetKey, now.millisecondsSinceEpoch);
    }
  }

  static DateTime _getThisWeeksFridayReset(DateTime now) {
    // Monday=1, Sunday=7
    int daysUntilFriday = (DateTime.friday - now.weekday) % 7;
    final friday = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: daysUntilFriday));
    return DateTime(friday.year, friday.month, friday.day, 11, 0);
  }

  static Future<void> _clearAllUsage() async {
    await GroupStorageService.clearAllUsage(); // implement below
  }

  /// Aggregate usage for all users from all groups
  static Future<Map<String, double>> getAllUsersUsage() async {
    final allSlots = await GroupStorageService.loadAllSlots();
    return UsageAggregationService.usagePerUserNameMB(allSlots);
  }
}
