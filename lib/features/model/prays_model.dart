import 'package:cloud_firestore/cloud_firestore.dart';

class PraysModel {
  String? id;
  String? devicesId;
  String? finishAsr;
  String? finishDhuhr;
  String? finishFajr;
  String? finishIsya;
  String? finishMaghrib;
  bool? isAsr;
  bool? isDhuhr;
  bool? isFajr;
  bool? isIsya;
  bool? isMaghrib;
  String? onAsr;
  String? onDhuhr;
  String? onFajr;
  String? onIsya;
  String? onMaghrib;
  Timestamp? timestamp;
  bool? isEmpty;

  PraysModel({
    this.id = '',
    this.devicesId,
    this.finishAsr,
    this.finishDhuhr,
    this.finishFajr,
    this.finishIsya,
    this.finishMaghrib,
    this.isAsr,
    this.isDhuhr,
    this.isFajr,
    this.isIsya,
    this.isMaghrib,
    this.onAsr,
    this.onDhuhr,
    this.onFajr,
    this.onIsya,
    this.onMaghrib,
    this.timestamp,
    this.isEmpty = true,
  });

  // Mengonversi dari JSON (Map<String, dynamic>) ke Model
  factory PraysModel.fromJson(Map<String, dynamic> json) {
    return PraysModel(
      devicesId: json['devices_id'] ?? '',
      finishAsr: json['finish_asr'] ?? '',
      finishDhuhr: json['finish_dhuhr'] ?? '',
      finishFajr: json['finish_fajr'] ?? '',
      finishIsya: json['finish_isya'] ?? '',
      finishMaghrib: json['finish_maghrib'] ?? '',
      isAsr: json['is_asr'] ?? false,
      isDhuhr: json['is_dhuhr'] ?? false,
      isFajr: json['is_fajr'] ?? false,
      isIsya: json['is_isya'] ?? false,
      isMaghrib: json['is_maghrib'] ?? false,
      onAsr: json['on_asr'] ?? '',
      onDhuhr: json['on_dhuhr'] ?? '',
      onFajr: json['on_fajr'] ?? '',
      onIsya: json['on_isya'] ?? '',
      onMaghrib: json['on_maghrib'] ?? '',
      timestamp: json['timestamp'] as Timestamp,
    );
  }

  // Mengonversi dari Model ke JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'devices_id': devicesId,
      'finish_asr': finishAsr,
      'finish_dhuhr': finishDhuhr,
      'finish_fajr': finishFajr,
      'finish_isya': finishIsya,
      'finish_maghrib': finishMaghrib,
      'is_asr': isAsr,
      'is_dhuhr': isDhuhr,
      'is_fajr': isFajr,
      'is_isya': isIsya,
      'is_maghrib': isMaghrib,
      'on_asr': onAsr,
      'on_dhuhr': onDhuhr,
      'on_fajr': onFajr,
      'on_isya': onIsya,
      'on_maghrib': onMaghrib,
      'timestamp': timestamp,
    };
  }
}
