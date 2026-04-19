import 'dart:async';
import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../services/group_storage_service.dart';
import '../services/time_scheduler.dart';
import 'notification_service.dart';

class GlobalTimerWatcher extends StatefulWidget {
  const GlobalTimerWatcher({super.key});

  @override
  State<GlobalTimerWatcher> createState() => _GlobalTimerWatcherState();
}

class _GlobalTimerWatcherState extends State<GlobalTimerWatcher> {
  Group? _currentGroup;
  Member? _lastActiveUser;
  int remainingSeconds = 0;
  Timer? _blockWatcher;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationService.init();
      await _loadGroupData();
      _startWatcher();
    });
  }

  Future<void> _loadGroupData() async {
    _currentGroup = await GroupStorageService.getCurrentGroup();
    _updateCurrentUserFromSchedule();
  }

  void _startWatcher() {
    _blockWatcher?.cancel();
    _blockWatcher = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCurrentUserFromSchedule();

      NotificationService.showPersistentTimerNotification(
        context: context,
        remainingSeconds: remainingSeconds,
      );

      if (remainingSeconds == 60) {
        NotificationService.showAlarmNotification(context, 'oneMinute');
      }

      if (remainingSeconds == 1) {
        NotificationService.showAlarmNotification(context, 'timeUp');
      }
    });
  }

  void _updateCurrentUserFromSchedule() {
    if (_currentGroup == null) return;

    final paused = TimeScheduler.isTimeBlockActive(_currentGroup!.timeBlocks);
    final current = TimeScheduler.getCurrentMember(_currentGroup!);

    Member? selected;
    int secs = 0;

    if (current != null) {
      selected = current;
      _lastActiveUser = current;
      final slot = _getCurrentSlotForMember(current);
      if (slot != null) secs = _secondsUntil(slot.end);
    } else if (paused) {
      selected = _lastActiveUser ?? TimeScheduler.getNextMember(_currentGroup!);
      if (selected != null) {
        final slot = _getCurrentSlotForMember(selected);
        if (slot != null) secs = _secondsUntil(slot.end);
      }
    }

    remainingSeconds = secs;
  }

  TimeRange? _getCurrentSlotForMember(Member member) {
    final now = TimeOfDay.now();
    for (final slot in member.scheduledSlots) {
      if (TimeScheduler.isTimeInRange(now, slot)) {
        return slot;
      }
    }
    return null;
  }

  int _secondsUntil(TimeOfDay end) {
    final now = DateTime.now();
    final nowDate = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
    var endDate = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    if (endDate.isBefore(nowDate)) {
      endDate = endDate.add(const Duration(days: 1));
    }
    return endDate.difference(nowDate).inSeconds;
  }

  @override
  void dispose() {
    _blockWatcher?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
