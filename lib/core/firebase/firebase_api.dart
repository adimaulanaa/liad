import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:liad/core/utils/device_info_plus.dart';
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

    // Jika fCMToken kosong, hentikan proses
    if (fCMToken == null) {
      return;
    }

    // Menampilkan debug token dan deviceId
    print('fCMToken : $fCMToken');
    print('deviceId : $deviceId');

    // Mencari apakah deviceId sudah ada di Firestore
    QuerySnapshot querySnapshot = await myStore.where('name', isEqualTo: deviceId).get();

    if (querySnapshot.docs.isEmpty) {
      // Jika data belum ada, insert data baru
      await myStore.add({
        'name': deviceId,
        'token': fCMToken,
        'created': now.toString(),
      });
      print('Data berhasil ditambahkan ke Firestore');
    } else {
      // Jika data sudah ada, lakukan update
      DocumentSnapshot existingDoc = querySnapshot.docs.first;
      await existingDoc.reference.update({
        'token': fCMToken,
        'created': now.toString(),
      });
      print('Data berhasil diperbarui di Firestore');
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
}
