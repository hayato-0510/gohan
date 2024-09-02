import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeyModel {
  late String _apiKey;

  Future<String> loadApiKey() async {
    try {
      await dotenv.load(fileName: ".env");
      _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
      if (_apiKey.isEmpty) {
        throw Exception('API key not found in .env file');
      }
      return _apiKey;
    } catch (e) {
      print('Error loading API key: $e');
      rethrow;
    }
  }
}
