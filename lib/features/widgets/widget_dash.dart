import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/media/media_text.dart';
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

DateTime setDateTimeSchaduleSecond(String time, date) {
  // Gabungkan menjadi satu string datetime
  String dateTimeString = "$date $time";

  // Format sesuai dengan input
  DateFormat format = DateFormat("dd-MM-yyyy HH:mm");

  // Parse ke DateTime
  DateTime combinedDateTime = format.parse(dateTimeString);
  return combinedDateTime;
}

Future<void> setValueSchadule(int type, bool value) async {
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

Future<String> getName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String myName = prefs.getString('myname') ?? StringResources.myName;
  return myName;
}

Future<String> getTypeWeather(int type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String data = '';
  if (type == 1) {
    data = prefs.getString('workWeather') ?? '';
  } else if (type == 2) {
    data = prefs.getString('homeWeather') ?? '';
  }
  return data;
}

/// Menghitung waktu yang tersisa menuju waktu sholat
String getRemainingTime(String prayerTime, DateTime currentTime) {
  // Ambil jam dan menit dari waktu sholat, misalnya "12:30"
  List<String> prayerTimeParts = prayerTime.split(":");
  int prayerHour = int.parse(prayerTimeParts[0]);
  int prayerMinute = int.parse(prayerTimeParts[1]);

  // Waktu sholat dalam objek DateTime
  DateTime prayerDateTime = DateTime(
    currentTime.year,
    currentTime.month,
    currentTime.day,
    prayerHour,
    prayerMinute,
  );

  // Jika waktu sholat sudah lewat, tambahkan sehari
  if (prayerDateTime.isBefore(currentTime)) {
    prayerDateTime = prayerDateTime.add(const Duration(days: 1));
  }

  // Menghitung selisih waktu
  Duration remainingDuration = prayerDateTime.difference(currentTime);

  // Mengonversi durasi menjadi format jam:menit:detik
  String remainingTime = formatDuration(remainingDuration);
  return "Next Prayer in : $remainingTime";
}

Center noData(bool isSholatFinish) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: isSholatFinish
          ? Text(
              'Jadwal sholat hari ini \nsudah selesai',
              textAlign: TextAlign.center,
              style: whiteTextstyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
            )
          : Text(
              'Data tidak tersedia',
              style: whiteTextstyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
            ),
    ),
  );
}
