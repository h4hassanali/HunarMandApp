import 'package:flutter/material.dart';
import '../../models/worker_model.dart';
import '../../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get worker from arguments
    final worker = ModalRoute.of(context)!.settings.arguments as WorkerModel;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        elevation: 0,
        backgroundColor: Colors.transparent, 
        foregroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar Placeholder
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              child: Text(
                worker.name.isNotEmpty ? worker.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Name & Skill
            Text(
              worker.name,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                worker.skill,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: theme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),

            const SizedBox(height: 30),

            // Details Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDetailRow(context, Icons.location_on, l10n.labelCity, worker.city),
                    const Divider(height: 30),
                    _buildDetailRow(context, Icons.work, l10n.profileExperience, '3 Years (Placeholder)'), // Placeholder
                    const Divider(height: 30),
                    _buildDetailRow(context, Icons.star, 'Rating', '4.8 (Placeholder)'), // Placeholder
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: worker.phone,
                      );
                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      }
                    },
                    icon: const Icon(Icons.call),
                    label: Text(l10n.profileCallNow),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 22),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
