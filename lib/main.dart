import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flux/firebase_options.dart';
import 'package:flux/screens/authentications/login_screen.dart';
import 'package:flux/screens/authentications/register_screen.dart';
import 'package:flux/screens/launch_app_screen.dart';
import 'package:flux/screens/navigation/home_screen.dart';
import 'package:flux/screens/navigation/posting_screen.dart';
import 'package:flux/screens/navigation/settings_screen.dart';
import 'package:flux/screens/profiles/insert_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferences.getInstance();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'launch',
      routes: {
        'launch': (context) => const LaunchAppScreen(),
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'insert': (context) => const InsertScreen(),
        'home': (context) => const HomeScreen(),
        'settings': (context) => const SettingsScreen(),
        'post': (context) => const PostingScreen(),
      },
    );
  }
}
