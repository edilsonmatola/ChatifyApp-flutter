import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String route) {
    // exit the current page and navigate to another one base on the given route
    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void nagivateRoute(String route) {
    // Navigate to other pages
    navigatorKey.currentState?.pushNamed(route);
  }

  void navigateToPage(Widget page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void goBack() {
    // Go back to the previous page/screen
    navigatorKey.currentState?.pop();
  }
}
