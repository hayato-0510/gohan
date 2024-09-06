class PhotoModel {
  final String url;
  final Map<String, dynamic>? attributes;

  const PhotoModel({
    required this.url,
    this.attributes,
  });

  // JSON からオブジェクトを生成するファクトリメソッド
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      url: json['url'] as String,
      attributes: json['attributes'] as Map<String, dynamic>?,
    );
  }

  // オブジェクトを JSON に変換するメソッド
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'attributes': attributes,
    };
  }

  // 等価性の比較
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoModel &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          _mapEquals(attributes, other.attributes);

  // ハッシュコード
  @override
  int get hashCode => url.hashCode ^ attributes.hashCode;

  // 文字列表現
  @override
  String toString() => 'PhotoModel(url: $url, attributes: $attributes)';

  // 新しい PhotoModel を生成するコピーメソッド
  PhotoModel copyWith({
    String? url,
    Map<String, dynamic>? attributes,
  }) {
    return PhotoModel(
      url: url ?? this.url,
      attributes: attributes ?? this.attributes,
    );
  }

  // Map の等価性を比較するヘルパーメソッド
  bool _mapEquals(Map<String, dynamic>? map1, Map<String, dynamic>? map2) {
    if (identical(map1, map2)) return true;
    if (map1 == null || map2 == null) return false;
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) return false;
    }
    return true;
  }
}
