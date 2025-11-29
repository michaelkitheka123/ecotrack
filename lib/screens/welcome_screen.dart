import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
// import 'dashboard_screen.dart'; // Placeholder if not implemented yet

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Logo or Icon
                GlassContainer(
                  padding: const EdgeInsets.all(30),
                  borderRadius: BorderRadius.circular(50),
                  child: const Icon(
                    Icons.eco,
                    size: 80,
                    color: AppTheme.primaryGreen,
                  ),
                )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.elasticOut)
                    .shimmer(delay: 1000.ms, duration: 1500.ms),

                const SizedBox(height: 40),

                Text(
                  'EcoTrack',
                  style: AppTheme.displayLarge,
                ).animate().fadeIn().slideY(begin: 0.3, end: 0),

                const SizedBox(height: 16),

                Text(
                  'Make Every Tree Count',
                  style: AppTheme.titleLarge.copyWith(color: Colors.white70),
                ).animate().fadeIn(delay: 300.ms),

                const Spacer(),

                // Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: const Text('Create Account'),
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5, end: 0),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      side: const BorderSide(color: AppTheme.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: AppTheme.titleLarge.copyWith(fontSize: 16),
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.5, end: 0),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    // );
                  },
                  child: Text(
                    'Continue as Guest',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white54),
                  ),
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
