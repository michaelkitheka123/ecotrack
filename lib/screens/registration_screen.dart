import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';
import '../theme.dart';
import 'dashboard_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // User registration data model
  Map<String, dynamic> userData = {
    'fullName': '',
    'email': '',
    'phone': '',
    'password': '',
    'avatarUrl': '',
    'region': '',
    'latitude': 0.0,
    'longitude': 0.0,
    'usesGPS': false,
    'userIntentTags': [],
    'expectedUsageType': '',
    'goalType': '',
    'targetAmount': 0,
    'timeline': '',
  };

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_formKey.currentState!.validate()) return;
      _formKey.currentState!.save();
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: 500.ms,
        curve: Curves.easeOutQuart,
      );
    } else {
      _completeRegistration();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: 500.ms,
        curve: Curves.easeOutQuart,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickAvatar() async {
    // Placeholder for image picker logic
    // In a real app, this would use ImagePicker
    debugPrint('Pick Avatar');
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userData['latitude'] = position.latitude;
        userData['longitude'] = position.longitude;
        userData['usesGPS'] = true;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get current location')),
      );
    }
  }

  Future<void> _completeRegistration() async {
    try {
      debugPrint('🔐 [REGISTRATION] Starting registration process...');

      // Create Firebase Auth user
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: userData['password'],
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      debugPrint('✅ [REGISTRATION] User created: ${user.uid}');

      // Initialize user document in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': userData['email'],
        'name': userData['fullName'],
        'phone': userData['phone'],
        'createdAt': FieldValue.serverTimestamp(),
        'stats': {
          'treesPlanted': 0,
          'co2Reduced': 0.0,
          'points': 0,
          'waterSaved': 0.0,
        },
        'settings': {
          'notifications': true,
          'darkMode': true,
          'dataSharing': true,
        },
        'profile': {
          'avatarUrl': userData['avatarUrl'],
          'region': userData['region'],
          'goalType': userData['goalType'],
          'latitude': userData['latitude'],
          'longitude': userData['longitude'],
          'usesGPS': userData['usesGPS'],
        },
        'onboarding': {
          'expectedUsageType': userData['expectedUsageType'],
          'targetAmount': userData['targetAmount'],
          'timeline': userData['timeline'],
        },
      });

      debugPrint('✅ [REGISTRATION] User data saved to Firestore');

      // Navigate to dashboard
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('❌ [REGISTRATION] Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildBasicInfoStep(),
                    _buildLocationStep(),
                    _buildPurposeStep(),
                    _buildGoalsStep(),
                  ],
                ),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _prevStep,
              ),
              const SizedBox(width: 8),
              Text(
                'Create Account',
                style: AppTheme.headlineLarge.copyWith(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Progress Indicator
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index <= _currentStep
                        ? AppTheme.primaryGreen
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ).animate(target: index <= _currentStep ? 1 : 0).color(
                      begin: Colors.white24,
                      end: AppTheme.primaryGreen,
                      duration: 300.ms,
                    ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(_currentStep == 3 ? 'Complete' : 'Next'),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryGreen, width: 2),
                  ),
                  child: userData['avatarUrl'].isEmpty
                      ? const Icon(Icons.camera_alt,
                          color: Colors.white70, size: 40)
                      : null, // Image would go here
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              label: 'Full Name',
              icon: Icons.person,
              onSaved: (v) => userData['fullName'] = v,
              validator: (v) =>
                  v?.isEmpty ?? true ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              onSaved: (v) => userData['email'] = v,
              validator: (v) =>
                  v?.isEmpty ?? true ? 'Please enter your email' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Phone (Optional)',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              onSaved: (v) => userData['phone'] = v,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
              onSaved: (v) => userData['password'] = v,
              validator: (v) => (v?.length ?? 0) < 6
                  ? 'Password must be at least 6 characters'
                  : null,
            ),
          ],
        ).animate().fadeIn().slideX(),
      ),
    );
  }

  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, size: 80, color: AppTheme.accentNeon),
          const SizedBox(height: 24),
          Text(
            'Where are you planting?',
            style: AppTheme.headlineLarge.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Help us suggest local tree species and connect you with nearby events.',
            style: AppTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          GlassContainer(
            child: ListTile(
              leading:
                  const Icon(Icons.my_location, color: AppTheme.primaryGreen),
              title: const Text('Use Current Location',
                  style: TextStyle(color: Colors.white)),
              onTap: _getCurrentLocation,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Or enter region/city',
            icon: Icons.map,
            onChanged: (v) => userData['region'] = v,
          ),
          if (userData['latitude'] != 0.0)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Location: ${userData['latitude'].toStringAsFixed(4)}, ${userData['longitude'].toStringAsFixed(4)}',
                style: const TextStyle(color: AppTheme.accentNeon),
              ),
            ),
        ],
      ).animate().fadeIn().slideX(),
    );
  }

  Widget _buildPurposeStep() {
    final options = [
      {'title': 'Student', 'desc': 'Learning & Projects'},
      {'title': 'NGO Worker', 'desc': 'Conservation Work'},
      {'title': 'Corporate', 'desc': 'CSR Initiatives'},
      {'title': 'Activist', 'desc': 'Climate Action'},
      {'title': 'Casual', 'desc': 'Personal Interest'},
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('How do you plan to use EcoTrack?',
            style: AppTheme.headlineLarge.copyWith(fontSize: 24)),
        const SizedBox(height: 24),
        ...options.map((opt) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassContainer(
                color: userData['expectedUsageType'] == opt['title']
                    ? AppTheme.primaryGreen.withOpacity(0.3)
                    : null,
                child: ListTile(
                  title: Text(opt['title']!,
                      style: AppTheme.titleLarge.copyWith(fontSize: 18)),
                  subtitle: Text(opt['desc']!, style: AppTheme.bodyMedium),
                  trailing: userData['expectedUsageType'] == opt['title']
                      ? const Icon(Icons.check_circle,
                          color: AppTheme.accentNeon)
                      : null,
                  onTap: () {
                    setState(() {
                      userData['expectedUsageType'] = opt['title'];
                    });
                  },
                ),
              ),
            )),
      ],
    ).animate().fadeIn().slideX();
  }

  Widget _buildGoalsStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Set your first goal',
              style: AppTheme.headlineLarge.copyWith(fontSize: 24)),
          const SizedBox(height: 32),
          GlassContainer(
            child: Column(
              children: [
                const Icon(Icons.flag, size: 48, color: AppTheme.accentNeon),
                const SizedBox(height: 16),
                Text('Plant Trees', style: AppTheme.titleLarge),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Target Number of Trees',
                  icon: Icons.forest,
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      userData['targetAmount'] = int.tryParse(v) ?? 0,
                ),
              ],
            ),
          ),
        ],
      ).animate().fadeIn().slideX(),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Function(String?)? onSaved,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
