import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/features/widgets/profile_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:alarm/alarm.dart';

Future<void> setAlarm(int id, DateTime date, String title, String body) async {
  // Periksa izin DND
  if (await Permission.accessNotificationPolicy.isDenied) {
    final status = await Permission.accessNotificationPolicy.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return;
    }
  }

  // Handle alarm sesuai izin DND
  if (await Permission.accessNotificationPolicy.isGranted) {
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: date,
      assetAudioPath: 'assets/ringtone/alarm-tone.mp3',
      loopAudio: false,
      vibrate: true,
      volume: 0.5,
      fadeDuration: 3.0,
      notificationSettings: NotificationSettings(
        body: body,
        title: title,
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  } else {
    // Jika izin tidak diberikan, hanya gunakan getar
    if (await Vibration.hasVibrator() ?? false) {
      Future.delayed(
        date.difference(DateTime.now()),
        () {
          Vibration.vibrate(duration: 1000); // Getar selama 1 detik
        },
      );
    }
  }
}

void setDataPray(
  BuildContext context,
  int id,
  bool isType,
  String timer,
) async {
  // Konversi timer menjadi DateTime
  var alarmDateTime = setDateTimeSchadule(timer);
  DateTime now = DateTime.now();
  if (alarmDateTime.isBefore(now) && !isType) {
    showSnackbar(context, 'Gagal membuat alarm, waktu telah berlalu.', false);
    return;
  }

  if (id == 1) {
    if (isType == false) {
      setAlarm(
        id,
        alarmDateTime,
        StringResources.titleFajr,
        StringResources.bodyFajr,
      );
    } else {
      await stopAlarmForToday(id);
    }
  } else if (id == 2) {
    if (isType == false) {
      setAlarm(
        id,
        alarmDateTime,
        StringResources.titleDhuhr,
        StringResources.bodyDhuhr,
      );
    } else {
      await stopAlarmForToday(id);
    }
  } else if (id == 3) {
    if (isType == false) {
      setAlarm(
        id,
        alarmDateTime,
        StringResources.titleAsr,
        StringResources.bodyAsr,
      );
    } else {
      await stopAlarmForToday(id);
    }
  } else if (id == 4) {
    if (isType == false) {
      setAlarm(
        id,
        alarmDateTime,
        StringResources.titleMaghrib,
        StringResources.bodyMaghrib,
      );
    } else {
      await stopAlarmForToday(id);
    }
  } else if (id == 5) {
    if (isType == false) {
      setAlarm(
        id,
        alarmDateTime,
        StringResources.titleIsha,
        StringResources.bodyIsha,
      );
    } else {
      await stopAlarmForToday(id);
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

Future<void> stopAlarmForToday(int id) async {
  // Ambil semua alarm
  final alarms = await Alarm.getAlarms();

  // Dapatkan tanggal hari ini
  final today = DateTime.now();

  // Filter alarm berdasarkan ID dan tanggal
  final alarmsToday = alarms.where((alarm) =>
      alarm.id == id &&
      alarm.dateTime.year == today.year &&
      alarm.dateTime.month == today.month &&
      alarm.dateTime.day == today.day);

  for (var alarm in alarmsToday) {
    await Alarm.stop(alarm.id); // Matikan alarm
  }
}

DateTime setDateTimeSchadule(String time) {
  final now = DateTime.now();
  final givenTime = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(time.split(":")[0]), // Jam
    int.parse(time.split(":")[1]), // Menit
  );
  return givenTime;
}
