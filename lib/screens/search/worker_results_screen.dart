import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hassan_app/widgets/footer_note.dart';
import 'package:url_launcher/url_launcher.dart';
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

  /// Launch phone dialer safely
  Future<void> _launchDialer(BuildContext context, String phoneNumber) async {
    final String trimmedNumber = phoneNumber.trim();
    if (trimmedNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('فون نمبر خالی ہے')));
      return;
    }

    final Uri uri = Uri(scheme: 'tel', path: trimmedNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ڈائلر کھولنے میں مسئلہ ہے۔')),
      );
    }
  }

  /// Copy phone number to clipboard
  void _copyPhone(BuildContext context, String phoneNumber) {
    final trimmedNumber = phoneNumber.trim();
    if (trimmedNumber.isEmpty) return;

    Clipboard.setData(ClipboardData(text: trimmedNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('فون نمبر کلپ بورڈ میں کاپی ہو گیا')),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;
    final String province = args?['province'] ?? '';
    final String city = args?['city'] ?? '';
    final String skill = args?['skill'] ?? '';

    _workersFuture = _workerService.fetchFilteredWorkers(
      city: city,
      skill: skill,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دستیاب کاریگر')),
      body: FooterNote(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<List<WorkerModel>>(
              future: _workersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: workers.length,
                        itemBuilder: (context, index) {
                          final worker = workers[index];
                          return WorkerCard(
                            worker: worker,
                            onCall: () => _launchDialer(context, worker.phone),
                            onCopy: () => _copyPhone(context, worker.phone),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'نوٹ:\nیہ پلیٹ فارم صرف کاریگروں اور صارفین کو آپس میں ملانے کے لیے ہے۔\nکسی بھی کام سے پہلے خود تسلی ضرور کریں۔',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
