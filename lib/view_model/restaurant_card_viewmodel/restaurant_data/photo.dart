export 'photo.dart';

class Photo {
  final String url;
  final Map<String, dynamic>? attributes;

  Photo({required this.url, this.attributes});
}