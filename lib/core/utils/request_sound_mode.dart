import 'package:permission_handler/permission_handler.dart';

Future<void> requestDoNotDisturbPermission() async {
  // Periksa status izin Do Not Disturb
  if (await Permission.accessNotificationPolicy.isDenied) {
    // Jika izin belum diberikan, minta izin
    final status = await Permission.accessNotificationPolicy.request();

    if (status.isGranted) {
      // ignore: avoid_print
      print("Izin Do Not Disturb diberikan.");
    } else if (status.isDenied) {
      // ignore: avoid_print
      print("Izin Do Not Disturb ditolak.");
    } else if (status.isPermanentlyDenied) {
      // ignore: avoid_print
      print(
          "Izin Do Not Disturb ditolak secara permanen. Harap ubah di pengaturan.");
      openAppSettings(); // Membuka pengaturan aplikasi jika izin ditolak permanen
    }
  } else {
    // ignore: avoid_print
    print("Izin Do Not Disturb sudah diberikan.");
  }
}
