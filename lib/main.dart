import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Supabase
  await Supabase.initialize(
    url: "https://mzyllpqtjmlrcavpkynn.supabase.co",
    anonKey: "sb_publishable_YQ8vhYw0zfi4ZQ1EZzGwTw_yOlFZssO",
  );

  /// Start app
  runApp(const MyApp());

  /// Initialize notifications in background
  Future.microtask(() async {

    await NotificationService.initialize();

  });

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Lawazia Pulse",
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );

  }

}