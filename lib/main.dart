import 'package:flutter/material.dart';

// Packages
import 'package:firebase_analytics/firebase_analytics.dart';

// Services
import './services/navigation_service.dart';

// pages
import './pages/splash_page.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () => runApp(
        MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: NavigationService.navigatorKey,
      title: 'Chatify',
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(36, 35, 49, 1),
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(30, 29, 37, 1),
        ),
      ),
    );
  }
}
