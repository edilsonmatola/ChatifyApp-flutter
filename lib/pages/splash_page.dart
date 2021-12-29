import 'package:flutter/material.dart';

// packages
import 'package:firebase_core/firebase_core.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
    required this.onInitializationComplete,
  }) : super(key: key);

  final VoidCallback onInitializationComplete;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // widget property to acess the methods from the super class
    _setup().then(
      (_) => widget.onInitializationComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatify',
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(36, 35, 49, 1),
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  'assets/images/logo.png',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    // Flutter ensures that all the widgets have been initialized
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  void _registerServices() {}
}
