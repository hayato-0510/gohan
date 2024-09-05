import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatelessWidget {
  final String url;
  const LottieAnimation({
    super.key, 
    required this.url
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: screenSize.width * 0.85,
        height: screenSize.height * 0.35,
        child: Lottie.network(
          url,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
