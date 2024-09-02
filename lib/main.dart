import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view/tab_page.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_location_viewmodel/user_location_viewmodel.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_search_settings_viewmodel/user_search_settings_viewmodel.dart';
import 'package:gohan/components/error_overlay/error_listener.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserLocationViewModel()),
        ChangeNotifierProvider(create: (_) => UserEngagementViewModel()),
        ChangeNotifierProvider(create: (_) => RestaurantCardViewModel()),
        ChangeNotifierProvider(create: (_) => UserSearchSettingsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSansJP',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
          ),
        ),
        home: ErrorListener(
          child: const BottomTabPage(),
        ),
      ),
    );
  }
}
