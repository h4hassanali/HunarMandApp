import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Gradient colors: Green -> Blue
    final gradientColors = [
      const Color(0xFF1F8A70),
      const Color(0xFF3A7CA5),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Icon with subtle scale animation
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.handyman_rounded,
                  size: 80,
                  color: theme.primaryColor,
                ),
              ).animate()
                .scale(duration: 600.ms, curve: Curves.easeOutBack)
                .fade(duration: 400.ms),

            const SizedBox(height: 20),

            // App Title with Slide & Fade
            const Text(
              'HunarMand Pakistan',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ).animate().slideY(begin: 0.3, end: 0).fade(delay: 200.ms, duration: 600.ms),

            const SizedBox(height: 10),

            // Tagline
            const Text(
              'Connecting Skills with Needs',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
            
            const SizedBox(height: 50),
            
            // Loading indicator at bottom
            const CircularProgressIndicator(
              color: Colors.white,
            ).animate().scale(delay: 1000.ms),
          ],
        ),
      ),
    ),
    );
  }
}
