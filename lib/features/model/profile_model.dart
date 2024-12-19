class UpdateNameModel {
  bool isError;
  String error;

  UpdateNameModel({
    this.isError = false,
    this.error = '',
  });
}


class ProfileModel {
  String? id;
  String? devicesId;
  String? connectId;
  String? connectName;
  String? name;
  String? latitude;
  String? longitude;
  String? timstamp;
  bool? isProfile;

  ProfileModel({
    this.id,
    this.devicesId,
    this.connectId,
    this.connectName,
    this.name,
    this.latitude,
    this.longitude,
    this.timstamp,
    this.isProfile,
  });

  // Method untuk membuat model dari Map (JSON)
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      devicesId: map['devices_id'],
      connectId: map['connect_id'],
      connectName: map['connect_name'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timstamp: map['timstamp'],
      isProfile: map['is_profile'],
    );
  }

  // Method untuk konversi model ke Map (untuk menyimpan ke Firestore, SharedPreferences, dll)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'connect_id': connectId,
      'connect_name': connectName,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'timstamp': timstamp,
      'is_profile': isProfile,
    };
  }
}
