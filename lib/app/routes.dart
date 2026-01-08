// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/worker/worker_registration_screen.dart';
import '../screens/worker/registration_success_screen.dart';
import '../screens/search/find_worker_screen.dart';
import '../screens/search/worker_results_screen.dart';

/// All routes used in the app are defined here
final Map<String, WidgetBuilder> appRoutes = {
  // '/': (context) => const HomeScreen(),
  '/worker-register': (context) => const WorkerRegistrationScreen(),
  '/register-success': (context) => const RegistrationSuccessScreen(),
  '/find-worker': (context) => const FindWorkerScreen(),
  '/worker-results': (context) => const WorkerResultsScreen(),
};
