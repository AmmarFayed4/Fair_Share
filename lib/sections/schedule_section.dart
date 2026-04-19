import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../services/group_storage_service.dart';
import '../services/time_scheduler.dart';
import '../services/prayer_time_service.dart';
import 'dart:math';
import 'package:fair_share/l10n/app_localizations.dart';

class ScheduleSection extends StatefulWidget {
  const ScheduleSection({Key? key}) : super(key: key);

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  Group? _group;
  Map<String, String>? _prayerTimes;
  bool _loading = true;
  final Map<String, Color> _userColors = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final group = await GroupStorageService.getCurrentGroup();
    final prayers = await PrayerTimesService.getPrayerTimes(context);

    // Assign each user a unique, consistent color
    if (group != null) {
      final random = Random(group.name.hashCode);
      for (final member in group.members) {
        _userColors[member.name] = Color.fromARGB(
          255,
          50 + random.nextInt(100), // 50–149
          50 + random.nextInt(100), // 50–149
          50 + random.nextInt(100), // 50–149
        );
      }
    }

    setState(() {
      _group = group;
      _prayerTimes = prayers;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_group == null) {
      return Center(child: Text(AppLocalizations.of(context)!.noGroupSelected));
    }

    final events = _buildDailyEvents(_group!, _prayerTimes!);
    final now = TimeOfDay.now();

    // Whole section scrolls naturally
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final e = events[index];
        final isCurrent = _isNowInRange(now, e.start, e.end);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF063a70), // row background
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Time box
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.blue.withOpacity(0.25)
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${_formatTime(e.start)} ${AppLocalizations.of(context)!.toLabel} ${_formatTime(e.end)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? Colors.blue : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Event box
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _getEventColor(
                      e.label,
                    ).withOpacity(isCurrent ? 0.9 : 0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      e.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<_ScheduleRow> _buildDailyEvents(
    Group group,
    Map<String, String> prayers,
  ) {
    final rows = <_ScheduleRow>[];

    // User slots
    final schedule = TimeScheduler.calculateTimeSlots(group);
    for (final member in schedule) {
      for (final slot in member.scheduledSlots) {
        rows.add(
          _ScheduleRow(start: slot.start, end: slot.end, label: member.name),
        );
      }
    }

    // Custom blocks
    for (final block in group.timeBlocks) {
      rows.add(
        _ScheduleRow(
          start: block.timeRange.start,
          end: block.timeRange.end,
          label: AppLocalizations.of(context)!.pausedBlockLabel(block.name),
        ),
      );
    }

    // Sort by start time
    rows.sort(
      (a, b) => _todToMinutes(a.start).compareTo(_todToMinutes(b.start)),
    );

    // Filter to 24h window from startTime
    final startMin = _todToMinutes(group.startTime);
    final endMin = (startMin + 24 * 60) % (24 * 60);
    return rows.where((r) {
      final s = _todToMinutes(r.start);
      if (startMin < endMin) {
        return s >= startMin && s < endMin;
      } else {
        return s >= startMin || s < endMin;
      }
    }).toList();
  }

  bool _isNowInRange(TimeOfDay now, TimeOfDay start, TimeOfDay end) {
    final nowMin = _todToMinutes(now);
    final startMin = _todToMinutes(start);
    final endMin = _todToMinutes(end);

    if (startMin <= endMin) {
      return nowMin >= startMin && nowMin < endMin;
    } else {
      return nowMin >= startMin || nowMin < endMin;
    }
  }

  int _todToMinutes(TimeOfDay tod) => tod.hour * 60 + tod.minute;

  String _formatTime(TimeOfDay tod) {
    final h = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final m = tod.minute.toString().padLeft(2, '0');
    final ampm = tod.period == DayPeriod.am
        ? AppLocalizations.of(context)!.timeAM
        : AppLocalizations.of(context)!.timePM;
    return '$h:$m $ampm';
  }

  Color _getEventColor(String label) {
    if (_userColors.containsKey(label)) {
      return _userColors[label]!;
    }
    if (label.startsWith('🕌')) {
      return Colors.orange.shade700;
    }
    if (label.startsWith('⏸')) {
      return Colors.orange.shade700;
    }
    return Colors.grey.shade700;
  }
}

class _ScheduleRow {
  final TimeOfDay start;
  final TimeOfDay end;
  final String label;
  _ScheduleRow({required this.start, required this.end, required this.label});
}
