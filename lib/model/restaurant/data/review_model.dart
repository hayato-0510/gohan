class ReviewModel {
  final String text;
  final double rating;
  final DateTime timestamp;

  const ReviewModel({
    required this.text,
    required this.rating,
    required this.timestamp,
  });

  // JSON からオブジェクトを生成するファクトリメソッド
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      text: json['text'] as String,
      rating: (json['rating'] as num).toDouble(),
      timestamp: DateTime.parse(json['time'] as String),
    );
  }

  // オブジェクトを JSON に変換するメソッド
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'rating': rating,
      'time': timestamp.toIso8601String(),
    };
  }

  // 等価性の比較
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewModel &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          rating == other.rating &&
          timestamp == other.timestamp;

  // ハッシュコード
  @override
  int get hashCode => text.hashCode ^ rating.hashCode ^ timestamp.hashCode;

  // 文字列表現
  @override
  String toString() =>
      'ReviewModel(text: $text, rating: $rating, timestamp: $timestamp)';

  // 新しい ReviewModel を生成するコピーメソッド
  ReviewModel copyWith({
    String? text,
    double? rating,
    DateTime? timestamp,
  }) {
    return ReviewModel(
      text: text ?? this.text,
      rating: rating ?? this.rating,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
