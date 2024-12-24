// To parse this JSON data, do
//
//     final weatherModel = weatherModelFromJson(jsonString);

import 'dart:convert';

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel data) => json.encode(data.toJson());

class WeatherModel {
  Lokasi? lokasi;
  List<WeatherDetail>? data;

  WeatherModel({
    this.lokasi,
    this.data,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        lokasi: Lokasi.fromJson(json["lokasi"]),
        data: List<WeatherDetail>.from(
            json["data"].map((x) => WeatherDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lokasi": lokasi!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'WeatherModel{lokasi: $lokasi, data: $data}';
  }
}

class WeatherDetail {
  Lokasi? lokasi;
  List<List<Cuaca>>? cuaca;

  WeatherDetail({
    this.lokasi,
    this.cuaca,
  });

  factory WeatherDetail.fromJson(Map<String, dynamic> json) => WeatherDetail(
        lokasi: Lokasi.fromJson(json["lokasi"]),
        cuaca: List<List<Cuaca>>.from(json["cuaca"]
            .map((x) => List<Cuaca>.from(x.map((x) => Cuaca.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "lokasi": lokasi!.toJson(),
        "cuaca": List<dynamic>.from(
            cuaca!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };

  @override
  String toString() {
    return 'WeatherDetail{lokasi: $lokasi, cuaca: $cuaca}';
  }
}

class Cuaca {
  DateTime? datetime;
  int? t;
  int? tcc;
  double? tp;
  int? weather;
  String? weatherDesc;
  String? weatherDescEn;
  int? wdDeg;
  String? wd;
  String? wdTo;
  double? ws;
  int? hu;
  int? vs;
  String? vsText;
  String? timeIndex;
  DateTime? analysisDate;
  String? image;
  DateTime? utcDatetime;
  DateTime? localDatetime;

  Cuaca({
    this.datetime,
    this.t,
    this.tcc,
    this.tp,
    this.weather,
    this.weatherDesc,
    this.weatherDescEn,
    this.wdDeg,
    this.wd,
    this.wdTo,
    this.ws,
    this.hu,
    this.vs,
    this.vsText,
    this.timeIndex,
    this.analysisDate,
    this.image,
    this.utcDatetime,
    this.localDatetime,
  });

  factory Cuaca.fromJson(Map<String, dynamic> json) => Cuaca(
        datetime: DateTime.parse(json["datetime"]),
        t: json["t"],
        tcc: json["tcc"],
        tp: json["tp"].toDouble(),
        weather: json["weather"],
        weatherDesc: json["weather_desc"],
        weatherDescEn: json["weather_desc_en"],
        wdDeg: json["wd_deg"],
        wd: json["wd"],
        wdTo: json["wd_to"],
        ws: json["ws"].toDouble(),
        hu: json["hu"],
        vs: json["vs"],
        vsText: json["vs_text"],
        timeIndex: json["time_index"],
        analysisDate: DateTime.parse(json["analysis_date"]),
        image: json["image"],
        utcDatetime: DateTime.parse(json["utc_datetime"]),
        localDatetime: DateTime.parse(json["local_datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "datetime": datetime.toString(),
        "t": t,
        "tcc": tcc,
        "tp": tp,
        "weather": weather,
        "weather_desc": weatherDesc,
        "weather_desc_en": weatherDescEn,
        "wd_deg": wdDeg,
        "wd": wd,
        "wd_to": wdTo,
        "ws": ws,
        "hu": hu,
        "vs": vs,
        "vs_text": vsText,
        "time_index": timeIndex,
        "analysis_date": analysisDate.toString(),
        "image": image,
        "utc_datetime": utcDatetime.toString(),
        "local_datetime": localDatetime.toString(),
      };

  @override
  String toString() {
    return 'Cuaca{datetime: $datetime, t: $t, tcc: $tcc, tp: $tp, weather: $weather, weatherDesc: $weatherDesc, weatherDescEn: $weatherDescEn, wdDeg: $wdDeg, wd: $wd, wdTo: $wdTo, ws: $ws, hu: $hu, vs: $vs, vsText: $vsText, timeIndex: $timeIndex, analysisDate: $analysisDate, image: $image, utcDatetime: $utcDatetime, localDatetime: $localDatetime}';
  }
}

class Lokasi {
  String? adm1;
  String? adm2;
  String? adm3;
  String? adm4;
  String? provinsi;
  String? kotkab;
  String? kecamatan;
  String? desa;
  double? lon;
  double? lat;
  String? timezone;
  String? type;

  Lokasi({
    this.adm1,
    this.adm2,
    this.adm3,
    this.adm4,
    this.provinsi,
    this.kotkab,
    this.kecamatan,
    this.desa,
    this.lon,
    this.lat,
    this.timezone,
    this.type,
  });

  factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
        adm1: json["adm1"],
        adm2: json["adm2"],
        adm3: json["adm3"],
        adm4: json["adm4"],
        provinsi: json["provinsi"],
        kotkab: json["kotkab"],
        kecamatan: json["kecamatan"],
        desa: json["desa"],
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble(),
        timezone: json["timezone"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "adm1": adm1,
        "adm2": adm2,
        "adm3": adm3,
        "adm4": adm4,
        "provinsi": provinsi,
        "kotkab": kotkab,
        "kecamatan": kecamatan,
        "desa": desa,
        "lon": lon,
        "lat": lat,
        "timezone": timezone,
        "type": type,
      };

  @override
  String toString() {
    return 'Lokasi{adm1: $adm1, adm2: $adm2, adm3: $adm3, adm4: $adm4, provinsi: $provinsi, kotkab: $kotkab, kecamatan: $kecamatan, desa: $desa, lon: $lon, lat: $lat, timezone: $timezone, type: $type}';
  }
}
