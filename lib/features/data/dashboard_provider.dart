import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liad/core/utils/location_service.dart';
import 'package:liad/features/data/dashboard_service.dart';
import 'package:liad/features/model/prays_model.dart';
import 'package:liad/features/model/profile_model.dart';
import 'package:liad/features/model/schedule_sholat_model.dart';
import 'package:liad/features/model/send_notif_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService dataService;
  final SharedPreferences prefs;
  String scheduleSholat = '00:00';
  String nameSholat = '-';

  DashboardProvider({required this.dataService, required this.prefs});

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

  Future<PraysModel> loadPrays() async {
    try {
      PraysModel data = await dataService.getPrays();
      notifyListeners();
      return data;
    } catch (e) {
      return PraysModel(isEmpty: true);
    }
  }

  Future<String> loadLocation() async {
    try {
      double latitude = await LocationService.isLatitude();
      double longitude = await LocationService.isLongitude();
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

  Future<void> updateScheduleSholat(int type, bool value, String prayId, pray) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
        await dataService.updateFinishPray(type, value, prayId, pray);
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

  Future<ProfileModel> getProfile() async {
    try {
      ProfileModel get = await dataService.getProfile();
      // Ambil data dari API atau Firebase, misalnya Firebase diutamakan
      ProfileModel data = get;
      notifyListeners();
      return data;
    } catch (e) {
      return ProfileModel();
    }
  }

  Future<UpdateNameModel> updateNames(String id, name) async {
    try {
      String get = await dataService.updateNames(id, name);
      await prefs.setString('myname', name);
      notifyListeners();
      return UpdateNameModel(isError: false, error: get);
    } catch (e) {
      return UpdateNameModel(isError: true, error: e.toString());
    }
  }

  Future<UpdateNameModel> updateConnect(String id, name) async {
    try {
      bool isSuc = false;
      String get = await dataService.updateConnect(id, name);
      if (get == '') {
        isSuc = true;
      }
      notifyListeners();
      return UpdateNameModel(isError: isSuc, error: get);
    } catch (e) {
      return UpdateNameModel(isError: true, error: e.toString());
    }
  }
}
