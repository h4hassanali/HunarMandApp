import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/language_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLocale.languageCode;
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.language,
        color: Theme.of(context).appBarTheme.iconTheme?.color,
      ),
      tooltip: currentLanguage == 'en' ? 'Language' : 'زبان',
      onSelected: (String languageCode) {
        languageProvider.changeLanguage(languageCode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              const Text('🇬🇧', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(
                l10n.languageEnglish,
                style: TextStyle(
                  fontWeight:
                      currentLanguage == 'en' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (currentLanguage == 'en') ...[
                const Spacer(),
                const Icon(Icons.check, color: Colors.green),
              ],
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'ur',
          child: Row(
            children: [
              const Text('🇵🇰', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(
                l10n.languageUrdu,
                style: TextStyle(
                  fontWeight:
                      currentLanguage == 'ur' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (currentLanguage == 'ur') ...[
                const Spacer(),
                const Icon(Icons.check, color: Colors.green),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
