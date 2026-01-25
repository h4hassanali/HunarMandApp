import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../models/worker_model.dart';
import '../../widgets/worker_card.dart';
import '../../widgets/shimmer_worker_card.dart';
import '../../data/worker_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WorkerResultsScreen extends StatefulWidget {
  const WorkerResultsScreen({super.key});

  @override
  State<WorkerResultsScreen> createState() => _WorkerResultsScreenState();
}

class _WorkerResultsScreenState extends State<WorkerResultsScreen> {
  late Future<List<WorkerModel>> _workersFuture;
  final WorkerService _workerService = WorkerService();
  bool _isLoading = true;

  void _copyPhone(BuildContext context, String phoneNumber) {
    final trimmed = phoneNumber.trim();
    if (trimmed.isEmpty) return;
    Clipboard.setData(ClipboardData(text: trimmed));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.phoneCopied)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;
    final String city = args?['city'] ?? '';
    final String skill = args?['skill'] ?? '';

    _workersFuture = _workerService.fetchFilteredWorkers(
      city: city,
      skill: skill,
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(title: Text(l10n.workerResultsTitle)),
        body: FutureBuilder<List<WorkerModel>>(
            future: _workersFuture,
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                itemCount: 5,
                padding: const EdgeInsets.only(top: 10),
                itemBuilder: (_, __) => const ShimmerWorkerCard(),
                );
            }
            if (snapshot.hasError) {
                return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.error_outline, size: 60, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text(l10n.errorLoadingCities, style: theme.textTheme.titleMedium),
                    ],
                ),
                );
            }

            final workers = snapshot.data ?? [];

            if (workers.isEmpty) {
                return Center(
                child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 20),
                        Text(
                        l10n.noWorkersFound,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                        l10n.noWorkersFoundDetail,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                        ),
                    ],
                    ),
                ),
                );
            }

            return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                itemCount: workers.length,
                itemBuilder: (context, index) {
                final worker = workers[index];
                return WorkerCard(
                    worker: worker,
                    onCopy: () => _copyPhone(context, worker.phone),
                ).animate().fadeIn(duration: 400.ms, delay: (50 * index).ms).slideX(begin: 0.2, end: 0);
                },
            );
            },
        ),
    );
  }
}
