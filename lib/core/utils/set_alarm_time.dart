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
      volume: 0.0,
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
