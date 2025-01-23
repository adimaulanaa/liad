import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:vibration/vibration.dart';

Future<void> handleAlarm() async {
  if (await Permission.accessNotificationPolicy.isGranted) {
    // Mainkan alarm jika izin diberikan
    // ignore: avoid_print
    print("Alarm dimainkan.");
    // Tambahkan logika pemutar alarm di sini
  } else {
    // Hanya getar jika izin tidak diberikan
    // ignore: avoid_print
    print("Hanya getar karena mode DND aktif.");
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000); // Getar selama 1 detik
    }
  }
}

Future<void> handleActiveAlarmSound(AlarmSettings alarm) async {
  Alarm.stop(1);
  
  RingerModeStatus ringerStatus = RingerModeStatus.unknown;
  try {
    ringerStatus = await SoundMode.ringerModeStatus;
  } catch (err) {
    ringerStatus = RingerModeStatus.unknown;
  }
}
