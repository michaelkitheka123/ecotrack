import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';

class Tip {
  final String title;
  final String description;
  final String category;
  final String icon;
  final int timeRequired; // minutes
  final double impact; // 1-10 scale
  final bool completed;

  Tip({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.timeRequired,
    required this.impact,
    this.completed = false,
  });
}

class TipsScreen extends StatelessWidget {
  TipsScreen({super.key});

  final List<Tip> dailyTips = [
    Tip(
      title: "Fix Leaky Faucets",
      description:
          "A dripping faucet can waste 20 gallons of water per day. Fix it today!",
      category: "Water Conservation",
      icon: "💧",
      timeRequired: 15,
      impact: 8.5,
    ),
    Tip(
      title: "Meat-Free Meal",
      description:
          "Try a plant-based meal today. Reduces CO2 by 2.5kg per meal.",
      category: "Diet",
      icon: "🥗",
      timeRequired: 0,
      impact: 9.0,
    ),
    Tip(
      title: "Public Transport",
      description: "Use bus/train instead of car for your commute today.",
      category: "Transportation",
      icon: "🚌",
      timeRequired: 10,
      impact: 7.5,
    ),
  ];

  final Map<String, List<Tip>> categorizedTips = {
    'Transportation': [
      Tip(
        title: "Carpool Weekly",
        description: "Share rides with colleagues 2+ times per week",
        category: "Transportation",
        icon: "🚗",
        timeRequired: 5,
        impact: 8.0,
      ),
      Tip(
        title: "Bike to Work",
        description: "Use bicycle for short commutes under 5km",
        category: "Transportation",
        icon: "🚲",
        timeRequired: 20,
        impact: 9.5,
      ),
    ],
    'Home Energy': [
      Tip(
        title: "LED Bulbs",
        description: "Replace incandescent bulbs with LED alternatives",
        category: "Home Energy",
        icon: "💡",
        timeRequired: 30,
        impact: 7.0,
      ),
      Tip(
        title: "Unplug Devices",
        description:
            "Unplug electronics when not in use to save phantom energy",
        category: "Home Energy",
        icon: "🔌",
        timeRequired: 2,
        impact: 6.5,
      ),
    ],
    'Waste Reduction': [
      Tip(
        title: "Reusable Bags",
        description: "Bring your own bags when shopping",
        category: "Waste Reduction",
        icon: "🛍️",
        timeRequired: 1,
        impact: 7.5,
      ),
    ],
  };

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
              _buildAppBar(context),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: AppTheme.primaryGreen,
                        unselectedLabelColor: Colors.white54,
                        indicatorColor: AppTheme.primaryGreen,
                        tabs: const [
                          Tab(text: 'Daily Tips'),
                          Tab(text: 'Learn More'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildDailyTips(),
                            _buildCategorizedTips(),
                          ],
                        ),
                      ),
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
            'Eco Tips',
            style: AppTheme.headlineLarge.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTips() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          "Today's Eco Challenges",
          style: AppTheme.titleLarge,
        ).animate().fadeIn().slideX(),
        const SizedBox(height: 16),
        ...dailyTips.map((tip) => _buildTipCard(tip)).toList(),
        const SizedBox(height: 24),
        Text(
          "Did You Know?",
          style: AppTheme.titleLarge,
        ).animate().fadeIn(delay: 300.ms).slideX(),
        const SizedBox(height: 8),
        GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "🌍 Climate Fact",
                style: AppTheme.titleLarge.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "If everyone in Kenya reduced their shower time by 2 minutes, "
                "we could save enough water to supply 500,000 households for a year!",
                style: AppTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms).scale(),
      ],
    );
  }

  Widget _buildCategorizedTips() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ...categorizedTips.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: AppTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ...entry.value.map((tip) => _buildTipCard(tip)).toList(),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTipCard(Tip tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(tip.icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: AppTheme.titleLarge.copyWith(fontSize: 18),
                      ),
                      Text(
                        tip.category,
                        style: AppTheme.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Text('${tip.timeRequired}m', style: AppTheme.bodyMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(tip.description, style: AppTheme.bodyLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Impact: ', style: AppTheme.bodyMedium),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: tip.impact / 10,
                      backgroundColor: Colors.white10,
                      valueColor:
                          const AlwaysStoppedAnimation(AppTheme.primaryGreen),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${tip.impact}/10', style: AppTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryGreen,
                    side: const BorderSide(color: AppTheme.primaryGreen),
                  ),
                  child: const Text('Mark Done'),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }
}
