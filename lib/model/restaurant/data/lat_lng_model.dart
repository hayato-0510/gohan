class LatLngModel {
  final double latitude;
  final double longitude;

  const LatLngModel({
    required this.latitude,
    required this.longitude,
  });

  // JSON からオブジェクトを生成するファクトリメソッド
  factory LatLngModel.fromJson(Map<String, dynamic> json) {
    return LatLngModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  // オブジェクトを JSON に変換するメソッド
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // 等価性の比較
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLngModel &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  // ハッシュコード
  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  // 文字列表現
  @override
  String toString() =>
      'LatLngModel(latitude: $latitude, longitude: $longitude)';

  // 新しい LatLngModel を生成するコピーメソッド
  LatLngModel copyWith({
    double? latitude,
    double? longitude,
  }) {
    return LatLngModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
