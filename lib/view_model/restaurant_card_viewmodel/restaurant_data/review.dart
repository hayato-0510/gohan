export 'review.dart';

class Review {
  final String text;
  final double rating;
  final DateTime timestamp;

  Review({
    required this.text,
    required this.rating,
    required this.timestamp,
  });
}