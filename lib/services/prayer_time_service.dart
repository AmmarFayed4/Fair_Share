import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fair_share/l10n/app_localizations.dart';

class PrayerTimesService {
  // Hardcoded API URL for Cairo, Egypt
  static const String _apiUrl =
      'https://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=5';

  // Get prayer times for Cairo only - hardcoded
  static Future<Map<String, String>> getPrayerTimes(
    BuildContext context,
  ) async {
    try {
      // Try to fetch from API first
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        final prayerTimes = {
          AppLocalizations.of(context)!.prayerFajr: timings['Fajr'].toString(),
          AppLocalizations.of(context)!.prayerDhuhr: timings['Dhuhr']
              .toString(),
          AppLocalizations.of(context)!.prayerAsr: timings['Asr'].toString(),
          AppLocalizations.of(context)!.prayerMaghrib: timings['Maghrib']
              .toString(),
          AppLocalizations.of(context)!.prayerIsha: timings['Isha'].toString(),
        };

        // Cache the successful response
        await _cachePrayerTimes(prayerTimes);

        return prayerTimes;
      } else {
        // If API fails, try to get cached data
        return await _getCachedPrayerTimes();
      }
    } catch (e) {
      // If everything fails, get cached data
      return await _getCachedPrayerTimes();
    }
  }

  // Cache prayer times with current date
  static Future<void> _cachePrayerTimes(Map<String, String> prayerTimes) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'prayerTimes': prayerTimes,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString('cached_prayer_times', json.encode(cacheData));
  }

  // Get cached prayer times if they're from today
  static Future<Map<String, String>> _getCachedPrayerTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_prayer_times');

      if (cachedData != null) {
        final decodedData = json.decode(cachedData);
        final prayerTimesMap =
            decodedData['prayerTimes'] as Map<String, dynamic>;
        final prayerTimes = prayerTimesMap.map(
          (key, value) => MapEntry(key, value.toString()),
        );

        final timestamp = DateTime.parse(decodedData['timestamp'] as String);

        // Only use cache if it's from today
        if (timestamp.day == DateTime.now().day) {
          return prayerTimes;
        }
      }
    } catch (e) {
      // Fall through to default times
    }

    // Return default times if no valid cache
    return {
      'Fajr': '05:30',
      'Dhuhr': '12:30',
      'Asr': '15:45',
      'Maghrib': '18:20',
      'Isha': '19:45',
    };
  }

  // Check if we have valid cached data
  static Future<bool> hasValidCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_prayer_times');

      if (cachedData != null) {
        final decodedData = json.decode(cachedData);
        final timestamp = DateTime.parse(decodedData['timestamp'] as String);
        return timestamp.day == DateTime.now().day;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  // Get the last fetch date for display
  static Future<String> getLastFetchDate(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_prayer_times');

      if (cachedData != null) {
        final decodedData = json.decode(cachedData);
        final timestamp = DateTime.parse(decodedData['timestamp'] as String);
        return AppLocalizations.of(context)!.lastUpdated(
          '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
        );
      }
    } catch (e) {
      return AppLocalizations.of(context)!.lastUpdatedNever;
    }
    return 'Last updated: Never';
  }

  // Convert prayer time string to DateTime for today
  static DateTime parsePrayerTime(String timeString) {
    final now = DateTime.now();
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  // Check if current time is within any prayer time (30 minutes duration)
  static bool isPrayerTime(Map<String, String> prayerTimes) {
    final now = DateTime.now();

    for (final prayer in prayerTimes.values) {
      final prayerTime = parsePrayerTime(prayer);
      final prayerEndTime = prayerTime.add(const Duration(minutes: 30));

      if (now.isAfter(prayerTime) && now.isBefore(prayerEndTime)) {
        return true;
      }
    }

    return false;
  }

  // Get next prayer time
  static Map<String, dynamic> getNextPrayer(
    Map<String, String> prayerTimes,
    BuildContext context,
  ) {
    final now = DateTime.now();
    DateTime? nextPrayerTime;
    String? nextPrayerName;

    for (final entry in prayerTimes.entries) {
      final prayerTime = parsePrayerTime(entry.value);

      if (prayerTime.isAfter(now) &&
          (nextPrayerTime == null || prayerTime.isBefore(nextPrayerTime))) {
        nextPrayerTime = prayerTime;
        nextPrayerName = entry.key;
      }
    }

    if (nextPrayerTime == null) {
      final firstPrayerTime = parsePrayerTime(
        prayerTimes[AppLocalizations.of(context)!.prayerFajr]!,
      );
      return {
        'name': AppLocalizations.of(context)!.fajrTomorrow,
        'time': firstPrayerTime.add(const Duration(days: 1)),
      };
    }

    return {'name': nextPrayerName!, 'time': nextPrayerTime};
  }
}
