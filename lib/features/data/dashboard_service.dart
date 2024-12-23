import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:liad/features/model/prays_model.dart';
import 'package:liad/features/model/profile_model.dart';
import 'package:liad/features/model/schedule_sholat_model.dart';
import 'package:liad/features/model/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  // API URL (sesuaikan dengan endpoint API Anda)
  final String baseUrl = 'https://api.aladhan.com/v1/timings';

  // Method untuk mengambil data dari API
  Future<ScheduleSholatModel> getPrayerTimes(
      String date, double latitude, double longitude) async {
    final url = Uri.parse(
        '$baseUrl/$date?latitude=$latitude&longitude=$longitude&method=20');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Pastikan status response adalah OK
        if (data['code'] == 200) {
          // Ambil data timings
          final timings = data['data']['timings'];
          ScheduleSholatModel model = ScheduleSholatModel(
            fajr: timings['Fajr'],
            sunrise: timings['Sunrise'],
            dhuhr: timings['Dhuhr'],
            asr: timings['Asr'],
            sunset: timings['Sunset'],
            maghrib: timings['Maghrib'],
            isha: timings['Isha'],
            imsak: timings['Imsak'],
            midnight: timings['Midnight'],
            firstthird: timings['Firstthird'],
            lastthird: timings['Lastthird'],
          );
          ScheduleSholatModel setData = setDataModel(model);
          // Return data waktu sholat sebagai Map
          return setData;
        } else {
          throw Exception('Failed to load prayer times');
        }
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<PraysModel> getPrays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    PraysModel model = PraysModel();
    final CollectionReference myStore =
        FirebaseFirestore.instance.collection("Prays");
    try {
      String? deviceId = prefs.getString('devicesId');
      DateTime startOfDay = DateTime(now.year, now.month, now.day); // Awal hari
      DateTime endOfDay =
          DateTime(now.year, now.month, now.day, 23, 59, 59); // Akhir hari
      QuerySnapshot praysSnapshot = await myStore
          .where('devices_id', isEqualTo: deviceId)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();
      if (praysSnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = praysSnapshot.docs.first;
        model = PraysModel.fromJson(doc.data() as Map<String, dynamic>);
        model.id = doc.id;
        model.isEmpty = false;
        return model;
      } else {
        return model;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Gagal : $e');
    }
    return model;
  }

  Future<Cuaca> getWeather(String id) async {
    final url = 'https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parsing data ke WeatherModel
        final weatherModel = WeatherModel.fromJson(data);

        // Mendapatkan waktu sekarang
        final now = DateTime.now();

        // Mengambil daftar Cuaca yang sesuai dengan tanggal hari ini
        List<Cuaca> cuacaList = [];
        if (weatherModel.data != null) {
          for (var weatherDetail in weatherModel.data!) {
            if (weatherDetail.cuaca != null) {
              for (var cuacaItem in weatherDetail.cuaca!) {
                cuacaList.addAll(
                  cuacaItem.where((cuaca) =>
                      cuaca.localDatetime != null &&
                      DateFormat('yyyy-MM-dd').format(cuaca.localDatetime!) ==
                          DateFormat('yyyy-MM-dd').format(now)),
                );
              }
            }
          }
        }

        // Jika ada data cuaca hari ini, cari data berdasarkan waktu terdekat
        if (cuacaList.isNotEmpty) {
          // Urutkan berdasarkan selisih waktu
          cuacaList.sort((a, b) {
            final diffA = a.localDatetime!.difference(now).abs();
            final diffB = b.localDatetime!.difference(now).abs();
            return diffA.compareTo(diffB);
          });

          // Ambil data cuaca terdekat
          return cuacaList.first;
        }

        return Cuaca();
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather data");
    }
  }

  Future<String> getLocationOSM(double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String res = '';
      final data = json.decode(response.body);
      res = data['address']['village'];
      return res;
    } else {
      throw Exception('-');
    }
  }

  Future<bool> sendNotification(
    String serverKey,
    String token,
    String title,
    String message,
  ) async {
    const String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/liad-apps/messages:send';
    token =
        'fzEbD4mGTPezClNjNEBLMQ:APA91bHaSrnt_n1Btq6zkA5zKm3O6IaUEggA0-hDjZwHLsT2xRzDZFLuSagnJDg_H-oXgad6qvtdZaBbLOGxiN2fWY6uB6kM2Ea9tUm9vFKaXPltEBIMO3o';

    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': title,
            'body': message,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
          },
        }),
      );

      if (response.statusCode == 200) {
        // print('Notification sent successfully!');
        return true;
      } else {
        // print('Failed to send notification: ${response.body}');
        throw Exception('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      // print('Error sending notification: $e');
      throw Exception(e);
    }
  }

  // Method untuk mengambil data dari Firebase
  Future<String> fetchPrayerScheduleFromFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('prayerSchedules')
          .doc('today')
          .get();
      if (snapshot.exists) {
        return snapshot.data()?['schedule'] ??
            '00:00'; // Ambil waktu sholat dari Firebase
      } else {
        throw Exception('No data found in Firebase');
      }
    } catch (e) {
      rethrow;
    }
  }

  ScheduleSholatModel setDataModel(ScheduleSholatModel model) {
    ScheduleSholatModel result = model;
    DateTime now = DateTime.now();
    // DateTime now = DateTime.parse('2024-12-10 22:06:32.015176');
    DateFormat timeFormat = DateFormat("HH:mm");

    // Mengonversi waktu sholat dari string ke DateTime
    DateTime fajr = timeFormat
        .parse(model.fajr.toString())
        .copyWith(year: now.year, month: now.month, day: now.day);
    DateTime dhuhr = timeFormat
        .parse(model.dhuhr.toString())
        .copyWith(year: now.year, month: now.month, day: now.day);
    DateTime asr = timeFormat
        .parse(model.asr.toString())
        .copyWith(year: now.year, month: now.month, day: now.day);
    DateTime maghrib = timeFormat
        .parse(model.maghrib.toString())
        .copyWith(year: now.year, month: now.month, day: now.day);
    DateTime isha = timeFormat
        .parse(model.isha.toString())
        .copyWith(year: now.year, month: now.month, day: now.day);

    // Tentukan waktu sholat yang sedang berlangsung atau berikutnya
    if (now.isBefore(fajr)) {
      result.scheduleName = 'Fajr';
      result.scheduleTime = model.fajr.toString();
    } else if (now.isBefore(dhuhr)) {
      result.scheduleName = 'Dhuhr';
      result.scheduleTime = model.dhuhr.toString();
    } else if (now.isBefore(asr)) {
      result.scheduleName = 'Asr';
      result.scheduleTime = model.asr.toString();
    } else if (now.isBefore(maghrib)) {
      result.scheduleName = 'Maghrib';
      result.scheduleTime = model.maghrib.toString();
    } else if (now.isBefore(isha)) {
      result.scheduleName = 'Isha';
      result.scheduleTime = model.isha.toString();
    } else {
      result.isFinis = true;
    }

    return result;
  }

  Future<ProfileModel> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ProfileModel model = ProfileModel();
    final CollectionReference myStore =
        FirebaseFirestore.instance.collection("Profile");
    try {
      String? deviceId = prefs.getString('devicesId');
      QuerySnapshot querySnapshot =
          await myStore.where('devices_id', isEqualTo: deviceId).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        model = ProfileModel.fromMap(doc.data() as Map<String, dynamic>);
        model.id = doc.id;
        if (model.name == '') {
          model.isSucces = false;
        }
        return model;
      } else {
        return model;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Gagal : $e');
    }
    return model;
  }

  Future<String> updateNames(String id, name) async {
    final CollectionReference myStore =
        FirebaseFirestore.instance.collection("Profile");
    try {
      DateTime now = DateTime.now();
      await myStore.doc(id).update({
        'name': name,
        'timstamp': now.toString(),
      });
      return 'Success';
    } catch (e) {
      // ignore: avoid_print
      print('Gagal : $e');
    }
    return '';
  }

  Future<String> updateConnect(String id, nameId) async {
    final CollectionReference myStore =
        FirebaseFirestore.instance.collection("Profile");
    try {
      DateTime now = DateTime.now();
      String name = '';
      DocumentSnapshot docSnapshot = await myStore.doc(nameId).get();
      if (docSnapshot.exists) {
        ProfileModel model =
            ProfileModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
        name = model.name.toString();
      }
      if (name != '') {
        await myStore.doc(id).update({
          'connect_id': nameId,
          'connect_name': name,
          'timstamp': now.toString(),
        });
        return 'Success';
      } else {
        return '';
      }
    } catch (e) {
      // ignore: avoid_print
      print('Gagal : $e');
    }
    return '';
  }

  Future<String> updateWeather(int type, String id, lat, long) async {
    final CollectionReference myStore =
        FirebaseFirestore.instance.collection("Profile");
    DateTime now = DateTime.now();
    Map<String, dynamic> updateData = {};
    switch (type) {
      case 1: // Fajr
        updateData = {
          'lat_work_weather': lat,
          'long_work_weather': long,
          'timstamp': now.toString(),
        };
        break;
      case 2: // Dhuhr
        updateData = {
          'lat_home_weather': lat,
          'long_home_weather': long,
          'timstamp': now.toString(),
        };
        break;
      default:
        return '';
    }
    try {
      await myStore.doc(id).update({
        ...updateData,
      });
      return 'Berhasil';
    } catch (e) {
      // ignore: avoid_print
      print('Gagal memperbarui data: $e');
    }
    return '';
  }

  Future<void> updateFinishPray(int type, bool value, String id, pray) async {
    final CollectionReference myStore =
        FirebaseFirestore.instance.collection("Prays");
    DateTime now = DateTime.now();
    // Logika untuk menentukan field berdasarkan `type`
    Map<String, dynamic> updateData = {};
    String time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    switch (type) {
      case 1: // Fajr
        updateData = {
          'is_fajr': value,
          'on_fajr': pray,
          'finish_fajr': time,
        };
        break;
      case 2: // Dhuhr
        updateData = {
          'is_dhuhr': value,
          'on_dhuhr': pray,
          'finish_dhuhr': time,
        };
        break;
      case 3: // Asr
        updateData = {
          'is_asr': value,
          'on_asr': pray,
          'finish_asr': time,
        };
        break;
      case 4: // Maghrib
        updateData = {
          'is_maghrib': value,
          'on_maghrib': pray,
          'finish_maghrib': time,
        };
        break;
      case 5: // Isya
        updateData = {
          'is_isya': value,
          'on_isya': pray,
          'finish_isya': time,
        };
        break;
      default:
        return; // Keluar jika type tidak valid
    }
    try {
      await myStore.doc(id).update({
        ...updateData,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Gagal memperbarui data: $e');
    }
  }
}
