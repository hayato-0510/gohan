class ReviewModel {
  final String text;
  final double rating;
  final DateTime timestamp;

  ReviewModel({
    required this.text,
    required this.rating,
    required this.timestamp,
  });


  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'text': text,
      'time': timestamp.toIso8601String(),
    };
  }
}
