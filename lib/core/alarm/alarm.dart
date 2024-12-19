import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkAndroidNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isDenied) {
    alarmPrint('Requesting notification permission...');
    final res = await Permission.notification.request();
    alarmPrint(
      'Notification permission ${res.isGranted ? '' : 'not '}granted',
    );
  }
}

Future<void> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  if (kDebugMode) {
    print('Schedule exact alarm permission: $status.');
  }
  if (status.isDenied) {
    if (kDebugMode) {
      print('Requesting schedule exact alarm permission...');
    }
    final res = await Permission.scheduleExactAlarm.request();
    if (kDebugMode) {
      print(
          'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
    }
  }
}


void stopAlarm(int alarmId) async {
  bool isStopped = await Alarm.stop(alarmId);

  if (isStopped) {
    if (kDebugMode) {
      print('Alarm $alarmId berhasil dimatikan.');
    }
  } else {
    if (kDebugMode) {
      print('Gagal mematikan alarm $alarmId.');
    }
  }
}