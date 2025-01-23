import 'package:flutter/services.dart';

class DoNotDisturbChecker {
  static const MethodChannel _channel = MethodChannel('com.example.liad/dnd');

  static Future<bool> isDoNotDisturbEnabled() async {
    try {
      final bool isDndEnabled = await _channel.invokeMethod('isDoNotDisturbEnabled');
      return isDndEnabled;
    } catch (e) {
      // ignore: avoid_print
      print("Error checking DND mode: $e");
      return false;
    }
  }
}
