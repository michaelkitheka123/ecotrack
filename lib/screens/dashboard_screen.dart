import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/user_data_provider.dart';
import 'welcome_screen.dart';
import 'progress_screen.dart';
import 'carbon_calculator_screen.dart';
import 'tips_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  Future<void> _signOut() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return ProgressScreen();
      case 2:
        return const CarbonCalculatorScreen();
      case 3:
        return TipsScreen();
      case 4:
        return ProfileScreen();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsCards(),
                    const SizedBox(height: 32),
                    Text(
                      'Recent Activity',
                      style: AppTheme.headlineLarge.copyWith(fontSize: 24),
                    ).animate().fadeIn().slideX(),
                    const SizedBox(height: 16),
                    _buildActivityList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final userData = Provider.of<UserDataProvider>(context);
    final displayName = userData.userName.isEmpty
        ? 'Friend'
        : userData.userName.split(' ').first;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $displayName! 👋',
                style: AppTheme.headlineLarge.copyWith(fontSize: 28),
              ),
              Text(
                'Ready to make an impact?',
                style: AppTheme.bodyLarge,
              ),
            ],
          ),
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout, color: Colors.white70),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildStatsCards() {
    final userData = Provider.of<UserDataProvider>(context);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Trees Planted',
            '${userData.treesPlanted}',
            Icons.forest,
            AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'CO2 Offset',
            '${userData.co2Reduced.toStringAsFixed(1)} kg',
            Icons.cloud_queue,
            Colors.blueAccent,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTheme.displayMedium.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    final userData = Provider.of<UserDataProvider>(context);
    final recentActivities = userData.getRecentActivities(limit: 5);

    if (recentActivities.isEmpty) {
      return GlassContainer(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.eco, size: 48, color: Colors.white24),
              const SizedBox(height: 12),
              Text(
                'No activities yet',
                style: AppTheme.bodyLarge.copyWith(color: Colors.white54),
              ),
              const SizedBox(height: 8),
              Text(
                'Start by calculating your carbon footprint!',
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 300.ms);
    }

    return Column(
      children: List.generate(recentActivities.length, (index) {
        final activity = recentActivities[index];
        IconData icon;
        Color iconColor;

        switch (activity.type) {
          case 'tree_planted':
            icon = Icons.park;
            iconColor = AppTheme.primaryGreen;
            break;
          case 'goal_completed':
            icon = Icons.flag;
            iconColor = Colors.amber;
            break;
          case 'calculation_done':
            icon = Icons.calculate;
            iconColor = Colors.blueAccent;
            break;
          case 'goal_created':
            icon = Icons.add_task;
            iconColor = AppTheme.accentNeon;
            break;
          default:
            icon = Icons.eco;
            iconColor = AppTheme.primaryGreen;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GlassContainer(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
              ),
              title: Text(
                activity.title,
                style: AppTheme.titleLarge.copyWith(fontSize: 18),
              ),
              subtitle: Text(
                '${activity.relativeTime} • ${activity.location}',
                style: AppTheme.bodyMedium,
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.white54),
            ),
          ),
        ).animate().fadeIn(delay: (300 + (index * 100)).ms).slideX();
      }),
    );
  }

  Widget _buildBottomNavBar() {
    return GlassContainer(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.black,
      opacity: 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0, label: 'Home'),
          _buildNavItem(Icons.show_chart, 1, label: 'Progress'),
          _buildNavItem(Icons.calculate, 2, isMain: true, label: 'Calculate'),
          _buildNavItem(Icons.lightbulb_outline, 3, label: 'Tips'),
          _buildNavItem(Icons.person, 4, label: 'Profile'),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 1, end: 0);
  }

  Widget _buildNavItem(IconData icon, int index,
      {bool isMain = false, String label = ''}) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: EdgeInsets.all(isMain ? 12 : 8),
        decoration: BoxDecoration(
          color: isMain
              ? AppTheme.primaryGreen
              : (isSelected ? Colors.white10 : Colors.transparent),
          shape: BoxShape.circle,
          boxShadow: isMain
              ? [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isMain || isSelected ? Colors.white : Colors.white54,
          size: isMain ? 32 : 24,
        ),
      ),
    );
  }
}
