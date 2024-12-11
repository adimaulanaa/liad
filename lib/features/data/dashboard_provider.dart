import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liad/core/utils/location_service.dart';
import 'package:liad/features/data/dashboard_service.dart';
import 'package:liad/features/model/schedule_sholat_model.dart';
import 'package:liad/features/model/send_notif_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService dataService;
  String scheduleSholat = '00:00';
  String nameSholat = '-';

  DashboardProvider({required this.dataService});

  // Method untuk mengambil data waktu sholat
  Future<ScheduleSholatModel> loadPrayerSchedule(String date) async {
    try {
      Position position = await LocationService.getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;
      // Ambil data dari API atau Firebase, misalnya Firebase diutamakan
      ScheduleSholatModel data =
          await dataService.getPrayerTimes(date, latitude, longitude);
      notifyListeners();
      return data;
    } catch (e) {
      return ScheduleSholatModel(isError: true, error: e.toString());
    }
  }

  Future<String> loadLocation() async {
    try {
      Position position = await LocationService.getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;
      // Ambil data dari API atau Firebase, misalnya Firebase diutamakan
      String data = await dataService.getLocationOSM(latitude, longitude);
      notifyListeners();
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future<SendNotifModel> sendNotif(String key, title, message) async {
    try {
      bool data = await dataService.sendNotification(key, '', title, message);
      notifyListeners();
      SendNotifModel model = SendNotifModel(isError: data);
      return model;
    } catch (e) {
      return SendNotifModel(isError: true, error: e.toString());
    }
  }

  Future<bool> loadScheduleSholat(int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil status sholat untuk fajr dan tipe lainnya
    bool fajr = prefs.getBool('isFajr') ?? false;
    bool dhuhr = prefs.getBool('isDhuhr') ?? false;
    bool asr = prefs.getBool('isAsr') ?? false;
    bool maghrib = prefs.getBool('isMaghrib') ?? false;
    bool isha = prefs.getBool('isIsha') ?? false;

    // Variabel untuk hasil
    bool result = false;

    // Tentukan status berdasarkan tipe
    switch (type) {
      case 1:
        result = fajr;
        break;
      case 2:
        result = dhuhr;
        break;
      case 3:
        result = asr;
        break;
      case 4:
        result = maghrib;
        break;
      case 5:
        result = isha;
        break;
      default:
        result = false; // jika type tidak sesuai
        break;
    }
    return result;
  }

  Future<void> updateScheduleSholat(int type, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Tentukan status berdasarkan tipe
    switch (type) {
      case 1:
        await prefs.setBool('isFajr', value);
        break;
      case 2:
        await prefs.setBool('isDhuhr', value);
        break;
      case 3:
        await prefs.setBool('isAsr', value);
        break;
      case 4:
        await prefs.setBool('isMaghrib', value);
        break;
      case 5:
        await prefs.setBool('isIsha', value);
        break;
      default:
        break;
    }
  }
}
