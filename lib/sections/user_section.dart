import 'dart:async';
import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../services/group_storage_service.dart';
import '../services/prayer_time_service.dart';
import '../services/time_scheduler.dart';
import 'package:fair_share/l10n/app_localizations.dart';
import 'package:fair_share/services/notification_service.dart';

class UserSection extends StatefulWidget {
  const UserSection({super.key});

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {
  // State
  Map<String, String> _prayerTimes = {};
  bool _isPrayerTime = false;
  String _lastUpdateTime = "loadng...";
  bool _usingCachedData = false;
  bool _isLoading = true;

  Group? _currentGroup;
  Member? _currentUser;
  bool _isUserActiveToday = false;
  Member? _lastActiveUser; // remembers who was active before pause
  bool _isPaused = false; // tracks if we’re in a pause block
  // Timers
  Timer? _blockWatcher; // watches time blocks to pause/resume
  // Optional UI refresher if you want extra smoothness (not strictly needed if the service ticks every second)
  // Timer? _uiTimer;
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();

    NotificationService.init(); // set up channels etc.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });

    _blockWatcher = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      // Update your UI state
      _updateCurrentUserFromSchedule();
    });
  }

  @override
  void dispose() {
    _blockWatcher?.cancel();
    // _uiTimer?.cancel();
    super.dispose();
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
      final slot = getCurrentSlotForMember(current);
      if (slot != null) secs = secondsUntil(slot.end);
    } else if (paused) {
      selected = _lastActiveUser ?? TimeScheduler.getNextMember(_currentGroup!);
      if (selected != null) {
        final slot = getCurrentSlotForMember(selected);
        if (slot != null) secs = secondsUntil(slot.end);
      }
    }

    if (!mounted) return;
    setState(() {
      _currentUser = selected;
      _isPaused = paused;
      remainingSeconds = secs;
    });
  }

  TimeRange? getCurrentSlotForMember(Member member) {
    final now = TimeOfDay.now();
    for (final slot in member.scheduledSlots) {
      if (TimeScheduler.isTimeInRange(now, slot)) {
        return slot;
      }
    }
    return null;
  }

  int secondsUntil(TimeOfDay end) {
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
      // Wrap to next day
      endDate = endDate.add(const Duration(days: 1));
    }

    return endDate.difference(nowDate).inSeconds;
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    // Start all futures in parallel
    final groupFuture = GroupStorageService.getCurrentGroup();
    final timesFuture = PrayerTimesService.getPrayerTimes(context);
    final lastUpdateFuture = PrayerTimesService.getLastFetchDate(context);
    final cacheFuture = PrayerTimesService.hasValidCache();

    // Wait for group first so we can update user immediately
    _currentGroup = await groupFuture;
    _isUserActiveToday = _isActiveDayForGroup(_currentGroup);
    _updateCurrentUserFromSchedule();

    // Wait for the rest
    final times = await timesFuture;
    final lastUpdate = await lastUpdateFuture;
    final usingCache = await cacheFuture;
    final isPrayerNow = PrayerTimesService.isPrayerTime(times);

    if (!mounted) return;
    setState(() {
      _prayerTimes = times;
      _lastUpdateTime = lastUpdate;
      _usingCachedData = usingCache;
      _isPrayerTime = isPrayerNow;
      _isLoading = false;
    });
  }

  bool _isAnyTimeBlockActive() {
    if (_currentGroup == null) return false;
    return TimeScheduler.isTimeBlockActive(_currentGroup!.timeBlocks);
  }

  bool _isActiveDayForGroup(Group? group) {
    if (group == null) return false;
    final weekday = DateTime.now().weekday; // 1=Mon ... 7=Sun
    return group.activeDays.contains(weekday);
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0)
      return AppLocalizations.of(context)!.durationHours(h) +
          ' ' +
          AppLocalizations.of(context)!.durationMinutes(m) +
          ' ' +
          AppLocalizations.of(context)!.durationSeconds(s);
    if (m > 0)
      return AppLocalizations.of(context)!.durationMinutes(m) +
          ' ' +
          AppLocalizations.of(context)!.durationSeconds(s);

    return AppLocalizations.of(context)!.durationSeconds(s);
  }

  double get progress {
    if (_currentUser == null) return 0;

    final slot = getCurrentSlotForMember(_currentUser!);
    if (slot == null) return 0;

    final totalSeconds = _secondsBetween(slot.start, slot.end);
    if (totalSeconds <= 0) return 0;

    return 1 - (remainingSeconds / totalSeconds);
  }

  int _secondsBetween(TimeOfDay start, TimeOfDay end) {
    int startMin = start.hour * 60 + start.minute;
    int endMin = end.hour * 60 + end.minute;
    if (endMin <= startMin) endMin += 24 * 60; // overnight wrap
    return (endMin - startMin) * 60;
  }

  @override
  Widget build(BuildContext context) {
    try {
      // listen: true
      final nextPrayer = _prayerTimes.isNotEmpty
          ? PrayerTimesService.getNextPrayer(
              _prayerTimes,
              context,
            ) // { 'name': String, 'time': DateTime }
          : {
              'name': AppLocalizations.of(context)!.noData,
              'time': DateTime.now(),
            };
      final isSessionActive = remainingSeconds > 0 && _currentUser != null;

      final isTimerPausedByBlock =
          isSessionActive &&
          _currentGroup != null &&
          TimeScheduler.isTimeBlockActive(_currentGroup!.timeBlocks);

      final currentTimeBlock = _currentGroup != null
          ? TimeScheduler.getCurrentTimeBlock(_currentGroup!.timeBlocks)
          : null;

      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: _currentUser != null
                          ? Colors.lightBlue
                          : Colors.grey,
                      child: Icon(
                        _currentUser != null ? Icons.person : Icons.group,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_currentUser != null)
                      Text(
                        _isPaused
                            ? '${_currentUser!.name} ${AppLocalizations.of(context)!.pausedSuffix}'
                            : _currentUser!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      Text(
                        AppLocalizations.of(context)!.noUserSelected,
                        style: TextStyle(color: Colors.grey),
                      ),
                    if (_currentUser != null)
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.sharesCountLabel(_currentUser!.shares),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    if (!_isUserActiveToday && _currentGroup != null)
                      Text(
                        AppLocalizations.of(context)!.notActiveToday,
                        style: TextStyle(
                          color: Colors.orange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Session Timer Card
              if (_isUserActiveToday && _currentUser != null)
                Card(
                  color: const Color(0xFF063a60),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.activeSessionTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (isSessionActive) ...[
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isTimerPausedByBlock
                                  ? Colors.orange
                                  : Colors.lightBlue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _formatDuration(remainingSeconds),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isTimerPausedByBlock
                                  ? Colors.orange
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (isTimerPausedByBlock && currentTimeBlock != null)
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.pausedWithBlock(currentTimeBlock.name),
                              style: const TextStyle(color: Colors.orange),
                              textAlign: TextAlign.center,
                            ),
                        ] else if (!isSessionActive &&
                            remainingSeconds == 0) ...[
                          Text(
                            AppLocalizations.of(context)!.sessionWillStart,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ] else if (!isSessionActive &&
                            remainingSeconds > 0) ...[
                          Text(
                            AppLocalizations.of(context)!.sessionPaused,
                            style: TextStyle(color: Colors.orange),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                )
              else if (_currentGroup != null)
                Card(
                  color: const Color(0xFF063a60),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.noActiveUserToday,
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Prayer Times Card
              Card(
                color: const Color(0xFF063a60),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.prayerTimesTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (_usingCachedData)
                            const Icon(
                              Icons.cloud_done,
                              color: Colors.orange,
                              size: 20,
                            ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            onPressed: _loadUserData,
                            tooltip: AppLocalizations.of(
                              context,
                            )!.refreshTimesTooltip,
                          ),
                        ],
                      ),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else ...[
                        if (_usingCachedData)
                          Text(
                            AppLocalizations.of(context)!.usingCachedData,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        Text(
                          _lastUpdateTime,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        if (_isPrayerTime)
                          Text(
                            AppLocalizations.of(context)!.timerPausedForPrayer,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 15),
                        if (_prayerTimes.isNotEmpty)
                          Column(
                            children: _prayerTimes.entries.map((entry) {
                              final isActive = PrayerTimesService.isPrayerTime({
                                entry.key: entry.value,
                              });
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isActive
                                              ? Colors.green
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isActive
                                            ? Colors.green
                                            : Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (isActive)
                                      const Icon(
                                        Icons.pause,
                                        color: Colors.green,
                                        size: 16,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        else
                          Text(
                            AppLocalizations.of(context)!.noPrayerTimes,
                            style: TextStyle(color: Colors.white70),
                          ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withAlpha(51),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.notifications_active,
                                color: Colors.lightBlue,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.nextPrayer(
                                    nextPrayer['name'] as String,
                                    _fmtTime(nextPrayer['time'] as DateTime),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (_currentGroup != null && _isAnyTimeBlockActive())
                Card(
                  color: Colors.orange.withAlpha(51),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.pause, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.timerPausedWithBlock(
                              TimeScheduler.getCurrentTimeBlock(
                                    _currentGroup!.timeBlocks,
                                  )?.name ??
                                  AppLocalizations.of(
                                    context,
                                  )!.timeBlockFallback,
                            ),
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    } catch (e, st) {
      debugPrint('Build error: $e\n$st');
      rethrow;
    }
  }

  static String _fmtTime(DateTime t) =>
      '${t.hour}:${t.minute.toString().padLeft(2, '0')}';
}
