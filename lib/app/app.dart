import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hassan_app/theme/app_theme.dart';
import 'routes.dart';
import '../screens/home/home_screen.dart';
import '../l10n/language_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isUrdu = languageProvider.currentLocale.languageCode == 'ur';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skilled Workers Pakistan',
      
      // Localization configuration
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ur'), // Urdu
      ],
      locale: languageProvider.currentLocale,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return supportedLocales.first;
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      
      // Apply theme (Urdu font is already in the theme)
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Use system dark/light mode
      routes: appRoutes,
      initialRoute: '/', // Start with Splash Screen
    );
  }
}
