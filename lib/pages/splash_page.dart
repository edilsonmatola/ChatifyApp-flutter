import 'package:flutter/material.dart';

// packages
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/navigation_service.dart';
import '../services/media_service.dart';
import '../services/cloud_storage_service.dart';

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
        // Splash Image on Initialization
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

  // Setting up the app
  Future<void> _setup() async {
    // Flutter ensures that all the widgets have been initialized
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  // App & Firebase Services
  void _registerServices() {
    // Creating a new instance of the Navigation Service
    GetIt.instance.registerSingleton<NavigationService>(
      NavigationService(),
    );

    // Creating a new instance of the Media Service
    GetIt.instance.registerSingleton<MediaService>(
      MediaService(),
    );

    // Creating a new instance of the Cloud Storage Service
    GetIt.instance.registerSingleton<CloudStorageService>(
      CloudStorageService(),
    );
  }
}
