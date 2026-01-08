import 'package:flutter/material.dart';
import 'package:hassan_app/widgets/footer_note.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl, // RTL for Urdu
      child: Scaffold(
        // No hardcoded background color, system theme will handle it
        body: FooterNote(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                // Center everything vertically
                child: SingleChildScrollView(
                  // In case of smaller screens
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hero / Top Section
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'ہنر مند پاکستان',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              // Color will automatically adapt to theme
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'آپ کے ہنر کو پہچانیں یا ضرورت مند کو ڈھونڈیں',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),

                      // Buttons Section inside a subtle card
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        // No hardcoded card color; uses default theme
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Button: Register as Worker
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/worker-register',
                                  );
                                },
                                icon: const Icon(Icons.handyman, size: 26),
                                label: const Text(
                                  'مجھے کام چاہیے',
                                  style: TextStyle(fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                  // Button colors follow theme
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Button: Find Skilled Worker
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/find-worker');
                                },
                                icon: const Icon(Icons.search, size: 26),
                                label: const Text(
                                  'مجھے کاریگر چاہیے',
                                  style: TextStyle(fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer tagline
                      const SizedBox(height: 30),
                      Text(
                        'ہنر مند پاکستان - آپ کا ہنر، آپ کی پہچان',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
