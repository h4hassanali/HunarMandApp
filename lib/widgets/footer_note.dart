import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.only(bottom: 20), // <-- bottom padding
          child: const Text(
            'یہ ایپ حسن علی نے تیار کی ہے',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'JameelNoori',
              fontSize: 17,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
