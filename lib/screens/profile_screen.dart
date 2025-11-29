import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../providers/user_data_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final user = _auth.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Profile Header
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                AppTheme.primaryGreen.withOpacity(0.2),
                            radius: 30,
                            backgroundImage: userData.avatarUrl.isNotEmpty
                                ? NetworkImage(userData.avatarUrl)
                                : null,
                            child: userData.avatarUrl.isEmpty
                                ? const Icon(Icons.person,
                                    size: 32, color: Colors.white70)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.userName.isEmpty
                                      ? 'User'
                                      : userData.userName,
                                  style: AppTheme.titleLarge,
                                ),
                                Text(
                                  user?.email ?? userData.userEmail,
                                  style: AppTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userData.joinDate != null
                                      ? 'Member since ${DateFormat('MMMM d, y').format(userData.joinDate!)}'
                                      : 'New member',
                                  style: AppTheme.bodyMedium.copyWith(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showEditProfileDialog(context),
                            icon: const Icon(Icons.edit,
                                color: AppTheme.accentNeon),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 16),

                    // App Settings
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App Settings',
                            style: AppTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildSettingSwitch(
                            'Push Notifications',
                            'Receive daily tips and reminders',
                            userData.notificationsEnabled,
                            (value) {
                              userData.updateSettings(notifications: value);
                            },
                          ),
                          _buildSettingSwitch(
                            'Dark Mode',
                            'Use dark theme in app',
                            userData.darkModeEnabled,
                            (value) {
                              userData.updateSettings(darkMode: value);
                            },
                          ),
                          _buildSettingSwitch(
                            'Data Sharing',
                            'Help improve app with anonymous data',
                            userData.dataSharingEnabled,
                            (value) {
                              userData.updateSettings(dataSharing: value);
                            },
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 100.ms).slideX(),

                    const SizedBox(height: 16),

                    // Stats Summary
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Impact',
                            style: AppTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                  '${userData.treesPlanted}', 'Trees', '🌳'),
                              _buildStatItem(
                                  '${userData.points}', 'Points', '⭐'),
                              _buildStatItem(
                                  '${userData.co2Reduced.toStringAsFixed(0)} kg',
                                  'CO₂ Saved',
                                  '🌍'),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 150.ms).slideX(),

                    const SizedBox(height: 16),

                    // Preferences
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preferences',
                            style: AppTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildPreferenceItem(
                              'Measurement Units', 'Metric (kg, km)'),
                          _buildPreferenceItem('Language', 'English'),
                          _buildPreferenceItem(
                              'Region',
                              userData.region.isEmpty
                                  ? 'Not set'
                                  : userData.region),
                          _buildPreferenceItem(
                              'Sustainability Goal', 'Reduce CO2 Emissions'),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideX(),

                    const SizedBox(height: 16),

                    // Support & About
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Support & About',
                            style: AppTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildSupportItem(
                              Icons.help, 'Help & Support', () {}),
                          _buildSupportItem(
                              Icons.description, 'Terms of Service', () {}),
                          _buildSupportItem(
                              Icons.security, 'Privacy Policy', () {}),
                          _buildSupportItem(
                              Icons.info, 'About Eco Track', () {}),
                          _buildSupportItem(
                              Icons.bug_report, 'Report a Bug', () {}),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(),

                    const SizedBox(height: 16),

                    // Data Management
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Management',
                            style: AppTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                              child: const Text('Export My Data'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () =>
                                  _showDeleteAccountDialog(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent),
                              ),
                              child: const Text('Delete Account'),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideX(),

                    const SizedBox(height: 24),

                    // App Version
                    Center(
                      child: Text(
                        'Eco Track v1.0.0',
                        style:
                            AppTheme.bodyMedium.copyWith(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            'Profile & Settings',
            style: AppTheme.headlineLarge.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(value,
            style: AppTheme.titleLarge
                .copyWith(fontSize: 20, color: AppTheme.primaryGreen)),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.bodyMedium.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _buildSettingSwitch(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTheme.bodyLarge),
      subtitle:
          Text(subtitle, style: AppTheme.bodyMedium.copyWith(fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryGreen,
    );
  }

  Widget _buildPreferenceItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTheme.bodyLarge),
          Row(
            children: [
              Text(value,
                  style: AppTheme.bodyMedium.copyWith(color: Colors.white54)),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem(IconData icon, String title, Function onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: AppTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: () => onTap(),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context, listen: false);
    final nameController = TextEditingController(text: userData.userName);
    final regionController = TextEditingController(text: userData.region);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: Text('Edit Profile', style: AppTheme.headlineLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: regionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Region',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              userData.updateProfile(
                name: nameController.text,
                region: regionController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated!')),
              );
            },
            child: const Text('Save',
                style: TextStyle(color: AppTheme.primaryGreen)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: Text('Delete Account', style: AppTheme.headlineLarge),
        content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: AppTheme.bodyLarge),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
