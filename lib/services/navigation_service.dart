import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String _route) {
    // exit the current page and navigate to another one base on the given route
    navigatorKey.currentState?.popAndPushNamed(_route);
  }

  void nagivateRoute(String _route) {
    // Navigate to other pages
    navigatorKey.currentState?.pushNamed(_route);
  }

  void navigateToPage(Widget _page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_context) => _page,
      ),
    );
  }

  void goBack() {
    // Go back to the previous page/screen
    navigatorKey.currentState?.pop();
  }
}
