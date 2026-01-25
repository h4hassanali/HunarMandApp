import 'package:flutter/material.dart';
import 'package:hassan_app/screens/splash_screen.dart';
import 'package:hassan_app/screens/main_screen.dart';
import 'package:hassan_app/screens/settings/settings_screen.dart';
import 'package:hassan_app/screens/settings/about_screen.dart';
import 'package:hassan_app/screens/worker/worker_profile_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/worker/worker_registration_screen.dart';
import '../screens/worker/registration_success_screen.dart';
import '../screens/search/find_worker_screen.dart';
import '../screens/search/worker_results_screen.dart';

/// All routes used in the app are defined here
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/main': (context) => const MainScreen(),
  '/home': (context) => const HomeScreen(),
  '/worker-register': (context) => const WorkerRegistrationScreen(),
  '/register-success': (context) => const RegistrationSuccessScreen(),
  '/find-worker': (context) => const FindWorkerScreen(),
  '/worker-results': (context) => const WorkerResultsScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/about': (context) => const AboutScreen(),
  '/worker-profile': (context) => const WorkerProfileScreen(),
};

