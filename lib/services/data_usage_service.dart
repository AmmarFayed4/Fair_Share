import 'dart:async';
import 'package:flutter/services.dart';

class DataUsageService {
  static const MethodChannel _ch = MethodChannel('com.fairshare/usage_stats');

  // bytes → MB
  static double _toMB(num bytes) => bytes / (1024 * 1024);

  static Future<bool> isUsageAccessGranted() async {
    return await _ch.invokeMethod<bool>('isUsageAccessGranted') ?? false;
  }

  static Future<void> openUsageAccessSettings() async {
    await _ch.invokeMethod('openUsageAccessSettings');
  }

  static Future<double> getMobileUsageMB(DateTime start, DateTime end) async {
    final bytes = await _ch.invokeMethod<int>('getMobileUsageBytes', {
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
    });
    return _toMB(bytes ?? 0);
  }
}
