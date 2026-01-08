import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hassan_app/widgets/footer_note.dart';
import '../../models/worker_model.dart';
import '../../widgets/worker_card.dart';
import '../../data/worker_service.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('فون نمبر کلپ بورڈ میں کاپی ہو گیا')),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('دستیاب کاریگر')),
        body: FooterNote(
          child: SafeArea(
            child: Stack(
              children: [
                FutureBuilder<List<WorkerModel>>(
                  future: _workersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoading();
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('کاریگر لوڈ کرنے میں مسئلہ ہوا'),
                      );
                    }

                    final workers = snapshot.data ?? [];

                    if (workers.isEmpty) {
                      return const Center(
                        child: Text(
                          'اس وقت اس شہر میں آپ کی منتخب کردہ مہارت کے کوئی کاریگر دستیاب نہیں ہیں۔',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: workers.length,
                      itemBuilder: (context, index) {
                        final worker = workers[index];
                        return WorkerCard(
                          worker: worker,
                          onCopy: () => _copyPhone(context, worker.phone),
                        );
                      },
                    );
                  },
                ),
                if (_isLoading)
                  Container(
                    color: Theme.of(
                      context,
                    ).scaffoldBackgroundColor.withValues(alpha: (0.6 * 255)),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: CircularProgressIndicator(strokeWidth: 5),
      ),
    );
  }
}
