import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Mendapatkan lokasi perangkat saat ini.
  static Future<Position> getCurrentLocation() async {
    // Memastikan layanan lokasi aktif
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi tidak aktif.');
    }

    // Memeriksa izin lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Izin lokasi ditolak secara permanen. Tidak dapat meminta izin.');
    }

    // Mendapatkan lokasi saat ini dengan pengaturan akurasi tinggi
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        distanceFilter: 100,
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
