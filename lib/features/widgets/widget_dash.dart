import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getDayName() {
  DateTime now = DateTime.now();
  switch (now.weekday) {
    case 1:
      return "Senin";
    case 2:
      return "Selasa";
    case 3:
      return "Rabu";
    case 4:
      return "Kamis";
    case 5:
      return "Jumat";
    case 6:
      return "Sabtu";
    case 7:
      return "Minggu";
    default:
      return "Tidak diketahui";
  }
}

String getAmPm(String time) {
  // Format waktu ke DateTime
  final dateFormat = DateFormat("HH:mm");
  final dateTime = dateFormat.parse(time);
  String check = dateTime.hour >= 12 ? "PM" : "AM";
  String res = '$time $check';

  // Cek AM atau PM
  return res;
}

/// Format durasi menjadi format jam:menit:detik
String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;
  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}

bool isTimeBeforeNow(String timeString) {
  // Parse timeString (e.g., "04:34") into a DateTime object for today
  final now = DateTime.now();
  final givenTime = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(timeString.split(":")[0]), // Jam
    int.parse(timeString.split(":")[1]), // Menit
  );

  // Return true if the current time is less than the given time
  return now.isBefore(givenTime);
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



  Future<void> setValueSchadule(int type, bool value)  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == 1) {
      await prefs.setBool('isFajr', value);
    } else if (type == 2) {
      await prefs.setBool('isDhuhr', value);
    } else if (type == 3) {
      await prefs.setBool('isAsr', value);
    } else if (type == 4) {
      await prefs.setBool('isMaghrib', value);
    } else if (type == 5) {
      await prefs.setBool('isIsha', value);
    }
  }