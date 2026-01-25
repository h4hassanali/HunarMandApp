import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class SavedWorkersScreen extends StatelessWidget {
  const SavedWorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Mock data for saved workers placeholder
    final bool hasFavorites = false; // Toggle this to see empty vs populated state (mock)

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Workers"),
      ),
      body: hasFavorites
          ? ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Text("A"),
                    ),
                    title: const Text("Ahmed Khan"),
                    subtitle: const Text("Electrician • Lahore"),
                    trailing: const Icon(Icons.favorite, color: Colors.red),
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    "No saved workers yet",
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap the heart icon on a worker to save them",
                     style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
    );
  }
}
