import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/config/theme_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// viewのインポート
import 'wrapper.dart';
// view_modelのインポート
import 'package:gohan/view_model/user_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_viewmodel/user_location_viewmodel.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_viewmodel/user_search_settings_viewmodel.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

/// Firebase関係のインポート
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';

void main() async {
  // Flutter Widgetバインディングを確実に初期化
  WidgetsFlutterBinding.ensureInitialized();
  
  // .envファイルを読み込む
  await dotenv.load(fileName: ".env");
  print('Loaded .env file: ${dotenv.env}');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserLocationViewModel()),
              ChangeNotifierProvider(create: (_) => UserEngagementViewModel()),
              ChangeNotifierProvider(create: (_) => RestaurantCardViewModel()),
              ChangeNotifierProvider(create: (_) => UserSearchSettingsViewModel()),
              ChangeNotifierProvider(create: (_) => AuthViewModel()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: appTheme,
              home: const AuthWrapper(),
            ),
          );
        }

        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}