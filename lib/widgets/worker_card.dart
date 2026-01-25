import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/worker_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerCard extends StatelessWidget {
  final WorkerModel worker;
  final VoidCallback? onCopy;

  const WorkerCard({super.key, required this.worker, this.onCopy});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Card(
      key: ValueKey(worker.id),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(
             context, 
             '/worker-profile',
             arguments: worker,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.primaryColor.withOpacity(0.1),
                child: Text(
                  worker.name.isNotEmpty ? worker.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        worker.skill,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          worker.city,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                       final Uri whatsappUri = Uri.parse("https://wa.me/${worker.phone}?text=Hello, I found you on HunarMand");
                       if (await canLaunchUrl(whatsappUri)) {
                         await launchUrl(whatsappUri);
                       }
                    },
                    icon: const Icon(Icons.chat, color: Colors.green),
                    tooltip: 'WhatsApp',
                  ),
                  IconButton(
                    onPressed: onCopy,
                    icon: const Icon(Icons.call, color: Colors.blue),
                    tooltip: l10n.btnCopyPhone,
                  ),
                  IconButton(
                    onPressed: () {
                      // Mock favorite toggle
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to Saved Workers")));
                    },
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                    tooltip: 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
