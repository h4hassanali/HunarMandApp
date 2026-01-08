import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hassan_app/widgets/footer_note.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/workers_data.dart';
import '../../widgets/worker_card.dart';

class WorkerResultsScreen extends StatelessWidget {
  const WorkerResultsScreen({super.key});

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
  Widget build(BuildContext context) {
    // Safe nullable arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;
    final String province = args?['province'] ?? '';
    final String city = args?['city'] ?? '';
    final String skill = args?['skill'] ?? '';

    // Filter registered workers (case-insensitive)
    final workers = registeredWorkers
        .where(
          (w) =>
              w.city.toLowerCase() == city.toLowerCase() &&
              w.skill.toLowerCase().contains(skill.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('دستیاب کاریگر')),
      body: FooterNote(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: workers.isEmpty
                      ? const Center(
                          child: Text(
                            'اس وقت اس شہر میں آپ کی منتخب کردہ مہارت کے کوئی کاریگر دستیاب نہیں ہیں۔',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: workers.length,
                          itemBuilder: (context, index) {
                            final worker = workers[index];

                            return WorkerCard(
                              worker: worker,
                              onCall: () =>
                                  _launchDialer(context, worker.phone),
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
            ),
          ),
        ),
      ),
    );
  }
}
