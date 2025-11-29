import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/user_data_provider.dart';

class CarbonCalculatorScreen extends StatefulWidget {
  const CarbonCalculatorScreen({super.key});

  @override
  State<CarbonCalculatorScreen> createState() => _CarbonCalculatorScreenState();
}

class _CarbonCalculatorScreenState extends State<CarbonCalculatorScreen> {
  double _carUsage = 150.0; // km per week
  double _electricityUsage = 350.0; // kWh per month
  int _meatMeals = 10; // per week
  double _flightHours = 2.0; // per year
  double _co2Result = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateCO2();
  }

  void _calculateCO2() {
    // Simplified calculation
    double transportCO2 = _carUsage * 0.21; // kg CO2 per km
    double energyCO2 = _electricityUsage * 0.5; // kg CO2 per kWh
    double dietCO2 = _meatMeals * 3.5; // kg CO2 per meat meal
    double travelCO2 = _flightHours * 90; // kg CO2 per flight hour

    setState(() {
      _co2Result = transportCO2 + energyCO2 + dietCO2 + travelCO2;
    });
  }

  void _saveResults() async {
    final userData = Provider.of<UserDataProvider>(context, listen: false);

    // Calculate individual components
    double transportCO2 = _carUsage * 0.21; // kg CO2 per km
    double energyCO2 = _electricityUsage * 0.5; // kg CO2 per kWh
    double dietCO2 = _meatMeals * 3.5; // kg CO2 per meat meal
    double travelCO2 = _flightHours * 90; // kg CO2 per flight hour

    await userData.updateCarbonFootprint(
      _co2Result,
      transportCO2: transportCO2,
      energyCO2: energyCO2,
      dietCO2: dietCO2,
      travelCO2: travelCO2,
      inputs: {
        'carUsage': _carUsage,
        'electricityUsage': _electricityUsage,
        'meatMeals': _meatMeals.toDouble(),
        'flightHours': _flightHours,
      },
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _co2Result < 12000
                ? 'Great! Your footprint is below average. +50 points!'
                : 'Carbon footprint saved. Try reducing your impact!',
          ),
          backgroundColor:
              _co2Result < 12000 ? AppTheme.primaryGreen : Colors.orange,
        ),
      );
      Navigator.pop(context);
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
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSection(
                        '🚗 Transportation',
                        'Weekly car usage (km)',
                        _carUsage,
                        (value) {
                          setState(() => _carUsage = value);
                          _calculateCO2();
                        },
                        0,
                        500,
                      ).animate().fadeIn().slideX(),
                      const SizedBox(height: 16),
                      _buildSection(
                        '🏠 Home Energy',
                        'Monthly electricity (kWh)',
                        _electricityUsage,
                        (value) {
                          setState(() => _electricityUsage = value);
                          _calculateCO2();
                        },
                        0,
                        1000,
                      ).animate().fadeIn(delay: 100.ms).slideX(),
                      const SizedBox(height: 16),
                      _buildSection(
                        '🍽️ Diet',
                        'Meat meals per week',
                        _meatMeals.toDouble(),
                        (value) {
                          setState(() => _meatMeals = value.toInt());
                          _calculateCO2();
                        },
                        0,
                        21,
                      ).animate().fadeIn(delay: 200.ms).slideX(),
                      const SizedBox(height: 16),
                      _buildSection(
                        '✈️ Air Travel',
                        'Flight hours per year',
                        _flightHours,
                        (value) {
                          setState(() => _flightHours = value);
                          _calculateCO2();
                        },
                        0,
                        50,
                      ).animate().fadeIn(delay: 300.ms).slideX(),
                      const SizedBox(height: 24),
                      _buildResultsCard(),
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
            'Carbon Calculator',
            style: AppTheme.headlineLarge.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, double value,
      Function(double) onChanged, double min, double max) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.titleLarge),
          Text(subtitle, style: AppTheme.bodyMedium),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryGreen,
              inactiveTrackColor: Colors.white24,
              thumbColor: AppTheme.accentNeon,
              overlayColor: AppTheme.primaryGreen.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min) > 0 ? (max - min).toInt() : 100,
              onChanged: onChanged,
            ),
          ),
          Text(
            value.toStringAsFixed(0),
            style: AppTheme.headlineLarge.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Your Carbon Footprint',
            style: AppTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            '${_co2Result.toStringAsFixed(1)} kg CO₂/year',
            style: AppTheme.displayMedium.copyWith(
              color: _co2Result < 12000 ? AppTheme.primaryGreen : Colors.orange,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _co2Result < 12000
                ? 'Great! Below Kenya average (12,000 kg)'
                : 'Above average - room for improvement!',
            style: AppTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveResults,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Results'),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }
}
