// To parse this JSON data, do
//
//     final scheduleSholatModel = scheduleSholatModelFromJson(jsonString);

import 'dart:convert';

ScheduleSholatModel scheduleSholatModelFromJson(String str) =>
    ScheduleSholatModel.fromJson(json.decode(str));

String scheduleSholatModelToJson(ScheduleSholatModel data) =>
    json.encode(data.toJson());

class ScheduleSholatModel {
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? sunset;
  String? maghrib;
  String? isha;
  String? imsak;
  String? midnight;
  String? firstthird;
  String? lastthird;
  String scheduleTime;
  String scheduleName;
  String error;
  bool isError;
  bool isFinis;

  ScheduleSholatModel({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
    this.scheduleTime = '',
    this.scheduleName = '',
    this.error = '',
    this.isError = false,
    this.isFinis = false,
  });

  factory ScheduleSholatModel.fromJson(Map<String, dynamic> json) =>
      ScheduleSholatModel(
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        sunset: json["Sunset"],
        maghrib: json["Maghrib"],
        isha: json["Isha"],
        imsak: json["Imsak"],
        midnight: json["Midnight"],
        firstthird: json["Firstthird"],
        lastthird: json["Lastthird"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": asr,
        "Sunset": sunset,
        "Maghrib": maghrib,
        "Isha": isha,
        "Imsak": imsak,
        "Midnight": midnight,
        "Firstthird": firstthird,
        "Lastthird": lastthird,
      };
}
