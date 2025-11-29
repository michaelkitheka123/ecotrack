import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'providers/user_data_provider.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('🔥 [FIREBASE] Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ [FIREBASE] Firebase initialized successfully');
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ],
        child: const EcoTrackApp(),
      ),
    );
  } catch (e) {
    debugPrint('❌ [FIREBASE] Firebase initialization failed: $e');
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Firebase initialization failed:\n\n$e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class EcoTrackApp extends StatefulWidget {
  const EcoTrackApp({super.key});

  @override
  State<EcoTrackApp> createState() => _EcoTrackAppState();
}

class _EcoTrackAppState extends State<EcoTrackApp> {
  @override
  void initState() {
    super.initState();
    // Initialize UserDataProvider when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      userDataProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTrack',
      theme: AppTheme.darkTheme,
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
