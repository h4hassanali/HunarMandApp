import 'package:flutter/material.dart';
import 'language_service.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('ur'); // Default to Urdu
  final LanguageService _languageService = LanguageService();

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  /// Load the saved language preference
  Future<void> _loadSavedLanguage() async {
    final languageCode = await _languageService.getSavedLanguage();
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  /// Change the app language
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;
    
    _currentLocale = Locale(languageCode);
    await _languageService.saveLanguage(languageCode);
    notifyListeners();
  }
}
