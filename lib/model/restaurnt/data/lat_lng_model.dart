class LatLngModel {
  final double latitude;
  final double longitude;

  LatLngModel(
    this.latitude, 
    this.longitude
  );

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}