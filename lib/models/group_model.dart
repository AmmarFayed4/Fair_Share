import 'package:flutter/material.dart';

class Group {
  final String id;
  final String name;
  final List<Member> members;
  final List<TimeBlock> timeBlocks;
  final List<int> activeDays; // 1-7 for Monday-Sunday
  final DateTime startDate;
  final TimeOfDay startTime;

  Group({
    required this.id,
    required this.name,
    required this.members,
    required this.timeBlocks,
    required this.activeDays,
    required this.startDate,
    required this.startTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': members.map((member) => member.toMap()).toList(),
      'timeBlocks': timeBlocks.map((block) => block.toMap()).toList(),
      'activeDays': activeDays,
      'startDate': startDate.toIso8601String(),
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      members: List<Member>.from(map['members'].map((x) => Member.fromMap(x))),
      timeBlocks: List<TimeBlock>.from(
        map['timeBlocks'].map((x) => TimeBlock.fromMap(x)),
      ),
      activeDays: List<int>.from(map['activeDays']),
      startDate: DateTime.parse(map['startDate']),
      startTime: TimeOfDay(
        hour: map['startTime']['hour'],
        minute: map['startTime']['minute'],
      ),
    );
  }
}

class Member {
  final String id;
  final String name;
  final double shares; // Changed from TimeRange to shares
  final List<TimeRange> scheduledSlots;

  Member({
    required this.id,
    required this.name,
    required this.shares, // Now this is just a number (1.0, 1.5, etc.)
    required this.scheduledSlots,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shares': shares, // Changed from dailyTime to shares
      'scheduledSlots': scheduledSlots.map((slot) => slot.toMap()).toList(),
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      name: map['name'],
      shares: map['shares'] ?? 1.0, // Default to 1 share
      scheduledSlots: List<TimeRange>.from(
        map['scheduledSlots'].map((x) => TimeRange.fromMap(x)),
      ),
    );
  }
}

class TimeBlock {
  final String id;
  final String name;
  final TimeRange timeRange;
  final bool pausesTimer; // Whether this block pauses user timers

  TimeBlock({
    required this.id,
    required this.name,
    required this.timeRange,
    this.pausesTimer = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'timeRange': timeRange.toMap(),
      'pausesTimer': pausesTimer,
    };
  }

  factory TimeBlock.fromMap(Map<String, dynamic> map) {
    return TimeBlock(
      id: map['id'],
      name: map['name'],
      timeRange: TimeRange.fromMap(map['timeRange']),
      pausesTimer: map['pausesTimer'] ?? true,
    );
  }
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});

  int get durationMinutes {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    // Handle overnight ranges (end time is next day)
    if (endMinutes < startMinutes) {
      return (24 * 60 - startMinutes) + endMinutes;
    }

    return endMinutes - startMinutes;
  }

  Map<String, dynamic> toMap() {
    return {
      'startHour': start.hour,
      'startMinute': start.minute,
      'endHour': end.hour,
      'endMinute': end.minute,
    };
  }

  factory TimeRange.fromMap(Map<String, dynamic> map) {
    return TimeRange(
      start: TimeOfDay(hour: map['startHour'], minute: map['startMinute']),
      end: TimeOfDay(hour: map['endHour'], minute: map['endMinute']),
    );
  }

  bool contains(TimeOfDay time) {
    final timeMinutes = time.hour * 60 + time.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return timeMinutes >= startMinutes && timeMinutes <= endMinutes;
  }
}
