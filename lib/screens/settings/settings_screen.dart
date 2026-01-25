import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isUrdu = languageProvider.currentLocale.languageCode == 'ur';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSectionHeader(context, "ACCOUNT"),
          Card(
             elevation: 0,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
               side: BorderSide(color: Colors.grey.shade200),
             ),
             child: Column(
               children: [
                 ListTile(
                   leading: const Icon(Icons.person_outline, color: Colors.purple),
                   title: const Text("My Profile"),
                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                   onTap: () {
                     // Navigate to profile edit (placeholder)
                   },
                 ),
                 const Divider(height: 1),
                 ListTile(
                   leading: const Icon(Icons.favorite_outline, color: Colors.red),
                   title: const Text("Saved Workers"),
                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                   onTap: () {
                      Navigator.pushNamed(context, '/saved-workers');
                   },
                 ),
                 const Divider(height: 1),
                  ListTile(
                   leading: const Icon(Icons.history, color: Colors.blue),
                   title: const Text("My Registrations"),
                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                   onTap: () {
                     // Placeholder
                   },
                 ),
               ],
             ),
          ),
          const SizedBox(height: 24),

          // Language Section
          _buildSectionHeader(context, l10n.settingsLanguage),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildLanguageTile(
                  context,
                  title: 'English',
                  subtitle: 'English',
                  flag: '🇬🇧',
                  isSelected: !isUrdu,
                  onTap: () => languageProvider.changeLanguage('en'),
                ),
                const Divider(height: 1),
                _buildLanguageTile(
                  context,
                  title: 'اردو',
                  subtitle: 'Urdu',
                  flag: '🇵🇰',
                  isSelected: isUrdu,
                  onTap: () => languageProvider.changeLanguage('ur'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // App Info Section
          _buildSectionHeader(context, l10n.settingsAppInfo),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blue),
                  title: Text(l10n.settingsAbout),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.pushNamed(context, '/about'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.mail_outline, color: Colors.orange),
                  title: Text(l10n.settingsContact),
                  subtitle: const Text('hassan@example.com'), // Placeholder
                  onTap: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'hassan@example.com',
                      query: 'subject=HunarMand App Support',
                    );
                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    }
                  },
                ),
                const Divider(height: 1),
                 ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: Colors.green),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to privacy policy or open URL
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          
          // Version Info
          Center(
            child: Text(
              'Version 1.0.0',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13, 
          fontWeight: FontWeight.bold, 
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.primaryColor : theme.textTheme.bodyLarge?.color,
        )
      ),
      subtitle: Text(subtitle),
      trailing: isSelected 
        ? Icon(Icons.check_circle, color: theme.primaryColor) 
        : null,
    );
  }
}
