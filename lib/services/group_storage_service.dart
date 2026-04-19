import 'dart:convert';
import 'time_scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/group_model.dart';
import 'usage_aggregation_service.dart';

class GroupStorageService {
  static const String _groupsKey = 'user_groups';
  static const String _currentGroupKey = 'current_group';

  // Save all groups
  static Future<void> saveGroups(List<Group> groups) async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = groups.map((group) => group.toMap()).toList();
    await prefs.setString(_groupsKey, json.encode(groupsJson));
  }

  // Load all groups
  static Future<List<Group>> loadGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString(_groupsKey);

    if (groupsJson != null) {
      try {
        final List<dynamic> groupsList = json.decode(groupsJson);
        return groupsList.map((groupMap) => Group.fromMap(groupMap)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  static Future<List<Slot>> loadAllSlots() async {
    final groups = await loadGroups();
    final List<Slot> allSlots = [];

    for (final group in groups) {
      final members = TimeScheduler.calculateTimeSlots(group);

      for (final member in members) {
        for (final range in member.scheduledSlots) {
          final start = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            range.start.hour,
            range.start.minute,
          );
          final end = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            range.end.hour,
            range.end.minute,
          );

          allSlots.add(
            Slot(
              userId: member.id,
              userName: member.name,
              start: start,
              end: end,
            ),
          );
        }
      }
    }
    return allSlots;
  }

  static const _usageKey = 'usageMap';

  /// Save usage map to local storage
  static Future<void> saveUsageMap(Map<String, double> usageMap) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(usageMap);
    await prefs.setString(_usageKey, jsonString);
  }

  /// Load usage map from local storage
  static Future<Map<String, double>> loadUsageMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usageKey);
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    return decoded.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );
  }

  /// Clear all usage data from local storage
  static Future<void> clearAllUsage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usageKey);
  }

  // Save current group ID
  static Future<void> saveCurrentGroupId(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentGroupKey, groupId);
  }

  // Get current group ID
  static Future<String?> getCurrentGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentGroupKey);
  }

  // Get current group
  static Future<Group?> getCurrentGroup() async {
    final groups = await loadGroups();
    final currentGroupId = await getCurrentGroupId();

    if (currentGroupId != null) {
      final matches = groups.where((g) => g.id == currentGroupId);
      if (matches.isNotEmpty) return matches.first;
      return groups.isNotEmpty ? groups.first : null;
    }
    return groups.isNotEmpty ? groups.first : null;
  }

  // Add or update a group
  static Future<void> saveGroup(Group group) async {
    final groups = await loadGroups();
    final index = groups.indexWhere((g) => g.id == group.id);

    if (index >= 0) {
      groups[index] = group;
    } else {
      groups.add(group);
    }

    await saveGroups(groups);
  }

  // Delete a group
  static Future<void> deleteGroup(String groupId) async {
    final groups = await loadGroups();
    groups.removeWhere((group) => group.id == groupId);
    await saveGroups(groups);
  }

  // Check if new group's active days conflict with existing groups
  static Future<bool> hasDayConflict(
    List<int> newActiveDays, {
    String? excludeGroupId,
  }) async {
    final groups = await loadGroups();

    for (final group in groups) {
      for (final day in newActiveDays) {
        if (excludeGroupId != null && group.id == excludeGroupId) {
          continue; // skip the group we're editing
        }
        if (group.activeDays.contains(day)) {
          return true; // Conflict found
        }
      }
    }

    return false; // No conflict
  }

  // Get available days that aren't taken by any group
  static Future<List<int>> getAvailableDays() async {
    final groups = await loadGroups();
    final allDays = [1, 2, 3, 4, 5, 6, 7];
    final takenDays = <int>{};

    for (final group in groups) {
      takenDays.addAll(group.activeDays);
    }

    return allDays.where((day) => !takenDays.contains(day)).toList();
  }
}
