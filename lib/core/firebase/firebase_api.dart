import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liad/core/utils/device_info_plus.dart';
import 'package:liad/core/utils/location_service.dart';
import 'package:liad/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notification
  Future<void> initNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    try {
      // Mendapatkan token FCM
      final fCMToken = await _firebaseMessaging.getToken();
      final CollectionReference myStore =
          FirebaseFirestore.instance.collection("Users");

      await _firebaseMessaging.requestPermission();
      await prefs.setString('token', fCMToken ?? '');

      // Mengambil deviceId dari SharedPreferences
      String? deviceId = prefs.getString('devicesId');

      // Jika deviceId belum ada, ambil dan simpan ke SharedPreferences
      if (deviceId == null) {
        deviceId = await getDeviceId();
        await prefs.setString('devicesId', deviceId);
      }

      // Mendapatkan lokasi menggunakan LocationService
      Position position = await LocationService.getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Jika fCMToken kosong, hentikan proses
      if (fCMToken == null) {
        return;
      }

      // Menampilkan debug token
      // ignore: avoid_print
      print('fCMToken : $fCMToken');

      // Mencari apakah deviceId sudah ada di Firestore
      QuerySnapshot querySnapshot =
          await myStore.where('name', isEqualTo: deviceId).get();

      if (querySnapshot.docs.isEmpty) {
        // Jika data belum ada, insert data baru
        await myStore.add({
          'name': deviceId,
          'token': fCMToken,
          'latitude': latitude,
          'longitude': longitude,
          'created': now.toString(),
        });
      } else {
        // Jika data sudah ada, lakukan update
        DocumentSnapshot existingDoc = querySnapshot.docs.first;
        await existingDoc.reference.update({
          'token': fCMToken,
          'latitude': latitude,
          'longitude': longitude,
          'created': now.toString(),
        });
      }
    } catch (e) {
      // Menangani error jika ada
      // ignore: avoid_print
      print('Gagal menambahkan atau memperbarui data di Firestore: $e');
    }
  }

  // function to handle received message firebase
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // navigator to new screen if user in taps notification
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  Future initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> initScheduleSholat() async {
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayString = prefs.getString('today') ?? '';
    if (todayString != '') {
      DateTime today = DateTime.parse(todayString);
      if (now.year == today.year &&
          now.month == today.month &&
          now.day == today.day) {
        //
      } else {
        await prefs.setBool('isFajr', false);
        await prefs.setBool('isDhuhr', false);
        await prefs.setBool('isAsr', false);
        await prefs.setBool('isMaghrib', false);
        await prefs.setBool('isIsha', false);
        await prefs.setString('today', now.toString());
      }
    } else {
      await prefs.setBool('isFajr', false);
      await prefs.setBool('isDhuhr', false);
      await prefs.setBool('isAsr', false);
      await prefs.setBool('isMaghrib', false);
      await prefs.setBool('isIsha', false);
      await prefs.setString('today', now.toString());
    }
  }
}
