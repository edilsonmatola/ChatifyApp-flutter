import 'package:flutter/material.dart';

// packages
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/navigation_service.dart';
import '../services/media_service.dart';
import '../services/cloud_storage_service.dart';
import 'package:chatifyapp/services/database_service.dart';

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

    // Delays 1 second before transitioning to the login screen/page
    Future.delayed(const Duration(seconds: 1)).then(
      (_) => _setup().then(
        (_) => widget.onInitializationComplete(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatify',
      theme: ThemeData(
        backgroundColor: const Color.fromRGBO(36, 35, 49, 1),
        scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1),
      ),
      home: Scaffold(
        // Splash Image on Initialization
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
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
      const MediaService(),
    );

    // Creating a new instance of the Cloud Storage Service
    GetIt.instance.registerSingleton<CloudStorageService>(
      CloudStorageService(),
    );

    // Creating a new instance of the Database Service
    GetIt.instance.registerSingleton<DatabaseService>(
      DatabaseService(),
    );
  }
}
