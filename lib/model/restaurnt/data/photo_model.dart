class PhotoModel {
  final String url;
  final Map<String, dynamic>? attributes;

  PhotoModel({
    required this.url, 
    this.attributes
    });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'attributes': attributes,
    };
  }
}