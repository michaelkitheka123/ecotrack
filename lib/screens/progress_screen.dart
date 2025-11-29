import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/user_data_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Stats Overview
                      GlassContainer(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Environmental Impact',
                              style:
                                  AppTheme.headlineLarge.copyWith(fontSize: 22),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                    'CO₂ Reduced',
                                    '${userData.co2Reduced.toStringAsFixed(1)} kg',
                                    '🌱'),
                                _buildStatItem('Trees Saved',
                                    '${userData.treesPlanted}', '🌳'),
                                _buildStatItem(
                                    'Water Saved',
                                    '${userData.waterSaved.toStringAsFixed(0)} L',
                                    '💧'),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 16),

                      // Level & Streak
                      GlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoColumn('Level', 'Eco Warrior'),
                            _buildInfoColumn('Streak', '14 days'),
                            _buildInfoColumn('Points', '${userData.points}'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 100.ms).slideX(),

                      const SizedBox(height: 16),

                      // Monthly Progress
                      GlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly CO₂ Reduction',
                              style: AppTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            _buildMonthlyProgressRow('Jan', 45.2),
                            _buildMonthlyProgressRow('Feb', 87.3),
                            _buildMonthlyProgressRow('Mar', 113.1),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideX(),

                      const SizedBox(height: 16),

                      // Achievements
                      GlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Achievements',
                              style: AppTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: [
                                _buildAchievementChip('First Step', '🚶'),
                                _buildAchievementChip('Energy Saver', '💡'),
                                _buildAchievementChip('Green Commuter', '🚲'),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideX(),
                    ],
                  ),
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
            'My Progress',
            style: AppTheme.headlineLarge.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.headlineLarge.copyWith(fontSize: 18),
        ),
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.headlineLarge.copyWith(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildMonthlyProgressRow(String month, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(month, style: AppTheme.bodyLarge),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value / 150,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation(AppTheme.primaryGreen),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Text(
              '${value.toStringAsFixed(1)} kg',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementChip(String name, String icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(name, style: AppTheme.bodyMedium),
        ],
      ),
    );
  }
}
