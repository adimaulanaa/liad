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
  String? connectName;
  String? connectId;
  String? latitude;
  String? longitude;
  String? name;
  String? timstamp;
  bool? isSucces;

  ProfileModel({
    this.id,
    this.devicesId,
    this.connectName,
    this.connectId,
    this.latitude,
    this.longitude,
    this.name,
    this.timstamp,
    this.isSucces = true,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String?, // Tambahkan jika 'id' diperlukan
      devicesId: map['devices_id'] as String? ?? '', 
      connectName: map['connect_name'] as String? ?? '', 
      connectId: map['connect_id'] as String? ?? '', 
      latitude: map['latitude']?.toString() ?? '', 
      longitude: map['longitude']?.toString() ?? '',
      name: map['name'] as String? ?? '',
      timstamp: map['timstamp'] as String? ?? '',
    );
  }
}

