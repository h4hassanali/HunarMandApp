import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class FooterNote extends StatelessWidget {
  final Widget child;

  const FooterNote({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child), // your original screen content
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            AppLocalizations.of(context)!.footerNote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
