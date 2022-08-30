import 'package:chatifyapp/src/core/constants/constants.dart';
import 'package:chatifyapp/src/features/home/presentation/home_page.dart';
import 'package:chatifyapp/src/features/splash/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/domain/domain.dart';
import 'src/features/authentication/authentication.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () => runApp(
        const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) => AuthenticationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatify',
        theme: ThemeData(
          backgroundColor: AppColors.appPrimaryBackgroundColor,
          scaffoldBackgroundColor: AppColors.appPrimaryBackgroundColor,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.appSecondaryBackgroundColor,
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext _context) => const LoginPage(),
          '/register': (BuildContext _context) => const RegisterPage(),
          '/home': (BuildContext _context) => const HomePage(),
        },
      ),
    );
  }
}
