import 'package:flutter/material.dart';
import '../models/group_model.dart';

class TimeScheduler {
  /// Calculate time slots for all members based on shares, time blocks,
  /// and the group's chosen start time.
  static List<Member> calculateTimeSlots(Group group) {
    final List<Member> scheduledMembers = [];

    // Use group's chosen start time
    final TimeOfDay dailyStart = group.startTime;
    final int startMinutes = _timeOfDayToMinutes(dailyStart);
    final int endMinutes = startMinutes + (24 * 60); // 24h later

    // Calculate total available minutes in the day (excluding pause blocks)
    final int totalAvailableMinutes = _calculateAvailableMinutes(
      group.timeBlocks,
    );

    // Calculate total shares
    final double totalShares = group.members.fold(
      0.0,
      (sum, member) => sum + member.shares,
    );

    // If no shares, return members with empty schedules
    if (totalShares == 0) {
      return group.members
          .map(
            (m) => Member(
              id: m.id,
              name: m.name,
              shares: m.shares,
              scheduledSlots: [],
            ),
          )
          .toList();
    }

    // Minutes per share
    final double minutesPerShare = totalAvailableMinutes / totalShares;

    int currentTimeMinutes = startMinutes;

    for (final member in group.members) {
      final List<TimeRange> memberSlots = [];
      int memberTotalMinutes = (minutesPerShare * member.shares).round();
      int remainingMinutes = memberTotalMinutes;

      while (remainingMinutes > 0 && currentTimeMinutes < endMinutes) {
        // Check if current time is inside a pause block
        final activeBlock = _getActiveTimeBlock(
          group.timeBlocks,
          _minutesToTimeOfDay(currentTimeMinutes),
        );

        if (activeBlock != null && activeBlock.pausesTimer) {
          // Skip to end of block
          final blockEnd = _timeOfDayToMinutes(activeBlock.timeRange.end);
          currentTimeMinutes = blockEnd < startMinutes
              ? blockEnd +
                    (24 * 60) // handle overnight
              : blockEnd;
          continue;
        }

        // Minutes until next pause block or end of day
        final availableMinutes = _getAvailableMinutes(
          group.timeBlocks,
          currentTimeMinutes,
          endMinutes,
        );

        if (availableMinutes <= 0) break;

        final slotMinutes = remainingMinutes < availableMinutes
            ? remainingMinutes
            : availableMinutes;

        final slotStart = _minutesToTimeOfDay(currentTimeMinutes);
        final slotEnd = _minutesToTimeOfDay(currentTimeMinutes + slotMinutes);

        memberSlots.add(TimeRange(start: slotStart, end: slotEnd));

        currentTimeMinutes += slotMinutes;
        remainingMinutes -= slotMinutes;
      }
      scheduledMembers.add(
        Member(
          id: member.id,
          name: member.name,
          shares: member.shares,
          scheduledSlots: memberSlots,
        ),
      );
    }

    return scheduledMembers;
  }

  /// Get the member currently active based on the schedule
  static Member? getCurrentMember(Group group) {
    final schedule = calculateTimeSlots(group);
    final nowTOD = TimeOfDay.now();

    for (final m in schedule) {
      if (m.scheduledSlots.any((slot) => isTimeInRange(nowTOD, slot))) {
        return m;
      }
    }
    return null;
  }

  /// Get the next member scheduled after now
  static Member? getNextMember(Group group) {
    final schedule = calculateTimeSlots(group);
    final nowMinutes = _timeOfDayToMinutes(TimeOfDay.now());

    for (final m in schedule) {
      for (final slot in m.scheduledSlots) {
        if (_timeOfDayToMinutes(slot.start) > nowMinutes) {
          return m;
        }
      }
    }
    return null;
  }

  /// Get remaining seconds for the current member's slot
  static int getRemainingSecondsForCurrentMember(Group group) {
    final current = getCurrentMember(group);
    if (current == null) return 0;

    final nowMinutes = _timeOfDayToMinutes(TimeOfDay.now());
    for (final slot in current.scheduledSlots) {
      if (isTimeInRange(TimeOfDay.now(), slot)) {
        final endMinutes = _timeOfDayToMinutes(slot.end);
        return (endMinutes - nowMinutes) * 60;
      }
    }
    return 0;
  }

  // ===== Internal helpers =====

  static int _calculateAvailableMinutes(List<TimeBlock> timeBlocks) {
    int totalMinutes = 24 * 60;
    final blockingRanges = _getNonOverlappingBlockingRanges(timeBlocks);
    for (final range in blockingRanges) {
      totalMinutes -= range.durationMinutes;
    }
    return totalMinutes > 0 ? totalMinutes : 0;
  }

  static List<TimeRange> _getNonOverlappingBlockingRanges(
    List<TimeBlock> timeBlocks,
  ) {
    final blockingRanges = <TimeRange>[];
    final pauseBlocks = timeBlocks.where((b) => b.pausesTimer).toList();
    if (pauseBlocks.isEmpty) return blockingRanges;

    pauseBlocks.sort(
      (a, b) =>
          _timeOfDayToMinutes(a.timeRange.start) -
          _timeOfDayToMinutes(b.timeRange.start),
    );

    blockingRanges.add(pauseBlocks[0].timeRange);

    for (int i = 1; i < pauseBlocks.length; i++) {
      final current = pauseBlocks[i];
      final last = blockingRanges.last;
      final lastEnd = _timeOfDayToMinutes(last.end);
      final currentStart = _timeOfDayToMinutes(current.timeRange.start);
      final currentEnd = _timeOfDayToMinutes(current.timeRange.end);

      if (currentStart <= lastEnd) {
        if (currentEnd > lastEnd) {
          blockingRanges[blockingRanges.length - 1] = TimeRange(
            start: last.start,
            end: current.timeRange.end,
          );
        }
      } else {
        blockingRanges.add(current.timeRange);
      }
    }
    return blockingRanges;
  }

  static TimeOfDay _minutesToTimeOfDay(int totalMinutes) {
    final minutesInDay = totalMinutes % (24 * 60);
    final hour = minutesInDay ~/ 60;
    final minute = minutesInDay % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static int _timeOfDayToMinutes(TimeOfDay tod) => tod.hour * 60 + tod.minute;

  static TimeBlock? _getActiveTimeBlock(
    List<TimeBlock> timeBlocks,
    TimeOfDay currentTime,
  ) {
    for (final block in timeBlocks) {
      if (isTimeInRange(currentTime, block.timeRange)) {
        return block;
      }
    }
    return null;
  }

  static bool isTimeInRange(TimeOfDay now, TimeRange range) {
    final nowMin = now.hour * 60 + now.minute;
    final startMin = range.start.hour * 60 + range.start.minute;
    final endMin = range.end.hour * 60 + range.end.minute;

    if (startMin <= endMin) {
      return nowMin >= startMin && nowMin < endMin;
    } else {
      // Overnight slot
      return nowMin >= startMin || nowMin < endMin;
    }
  }

  static int _getAvailableMinutes(
    List<TimeBlock> timeBlocks,
    int currentTimeMinutes,
    int endTimeMinutes,
  ) {
    int nextBlockStart = endTimeMinutes;

    for (final block in timeBlocks) {
      if (!block.pausesTimer) continue;
      final blockStart = _timeOfDayToMinutes(block.timeRange.start);
      if (blockStart > currentTimeMinutes && blockStart < nextBlockStart) {
        nextBlockStart = blockStart;
      }
    }
    return nextBlockStart - currentTimeMinutes;
  }

  static bool isTimeBlockActive(List<TimeBlock> timeBlocks) {
    final now = TimeOfDay.now();
    return timeBlocks.any(
      (block) => block.pausesTimer && isTimeInRange(now, block.timeRange),
    );
  }

  static TimeBlock? getCurrentTimeBlock(List<TimeBlock> timeBlocks) {
    final now = TimeOfDay.now();
    for (final block in timeBlocks) {
      if (isTimeInRange(now, block.timeRange)) {
        return block;
      }
    }
    return null;
  }
}
