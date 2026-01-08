import 'package:flutter/material.dart';
import 'package:hassan_app/theme/app_theme.dart';
import 'routes.dart';
import '../screens/home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skilled Workers Pakistan',
      // initialRoute: '/',
      theme: lightTheme, // Light theme
      darkTheme: darkTheme, // Dark theme
      themeMode: ThemeMode.system, // Use system dark/light mode
      routes: appRoutes,
      home: const HomeScreen(),
    );
  }
}
