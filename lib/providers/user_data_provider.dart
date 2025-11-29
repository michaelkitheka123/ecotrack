import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/goal.dart';
import '../models/activity.dart';
import '../models/carbon_calculation.dart';

class UserDataProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User ID
  String _userId = '';
  String get userId => _userId;

  // User Profile
  String _userName = '';
  String _userEmail = '';
  String _avatarUrl = '';
  String _region = '';
  DateTime? _joinDate;

  // Getters for profile
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get avatarUrl => _avatarUrl;
  String get region => _region;
  DateTime? get joinDate => _joinDate;

  // Stats
  double _co2Reduced = 0.0;
  int _treesPlanted = 0;
  int _points = 0;
  double _waterSaved = 0.0;

  // Getters for stats
  double get co2Reduced => _co2Reduced;
  int get treesPlanted => _treesPlanted;
  int get points => _points;
  double get waterSaved => _waterSaved;

  // Settings
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _dataSharingEnabled = true;

  // Getters for settings
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get dataSharingEnabled => _dataSharingEnabled;

  // Goals
  List<Goal> _goals = [];
  List<Goal> get goals => _goals;
  List<Goal> get activeGoals =>
      _goals.where((goal) => !goal.completed).toList();
  List<Goal> get completedGoals =>
      _goals.where((goal) => goal.completed).toList();

  // Activities
  List<Activity> _activities = [];
  List<Activity> get activities => _activities;
  List<Activity> getRecentActivities({int limit = 10}) {
    return _activities.take(limit).toList();
  }

  // Carbon Calculator Data
  double _lastCalculatedFootprint = 0.0;
  CarbonCalculation? _latestCalculation;

  double get lastCalculatedFootprint => _lastCalculatedFootprint;
  CarbonCalculation? get latestCalculation => _latestCalculation;

  // Initialization flag
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // ==================== INITIALIZATION ====================

  /// Initialize user data from Firebase
  Future<void> initialize() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('No user logged in');
      return;
    }

    _userId = user.uid;
    _userEmail = user.email ?? '';

    try {
      await loadFromFirestore();
      _listenToGoals();
      _listenToActivities();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing user data: $e');
    }
  }

  /// Load user data from Firestore
  Future<void> loadFromFirestore() async {
    try {
      final userData = await _firestoreService.getUserData(_userId);

      if (userData != null) {
        _userName = userData['name'] as String? ?? '';
        _userEmail = userData['email'] as String? ?? _userEmail;

        // Load stats
        final stats = userData['stats'] as Map<String, dynamic>?;
        if (stats != null) {
          _treesPlanted = stats['treesPlanted'] as int? ?? 0;
          _co2Reduced = (stats['co2Reduced'] as num?)?.toDouble() ?? 0.0;
          _points = stats['points'] as int? ?? 0;
          _waterSaved = (stats['waterSaved'] as num?)?.toDouble() ?? 0.0;
        }

        // Load settings
        final settings = userData['settings'] as Map<String, dynamic>?;
        if (settings != null) {
          _notificationsEnabled = settings['notifications'] as bool? ?? true;
          _darkModeEnabled = settings['darkMode'] as bool? ?? true;
          _dataSharingEnabled = settings['dataSharing'] as bool? ?? true;
        }

        // Load profile
        final profile = userData['profile'] as Map<String, dynamic>?;
        if (profile != null) {
          _avatarUrl = profile['avatarUrl'] as String? ?? '';
          _region = profile['region'] as String? ?? '';
        }

        // Load join date
        final createdAt = userData['createdAt'];
        if (createdAt != null) {
          _joinDate = (createdAt as Timestamp).toDate();
        }

        // Load latest calculation
        _latestCalculation =
            await _firestoreService.getLatestCalculation(_userId);
        if (_latestCalculation != null) {
          _lastCalculatedFootprint = _latestCalculation!.totalFootprint;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading from Firestore: $e');
    }
  }

  /// Save user data to Firestore
  Future<void> saveToFirestore() async {
    try {
      await _firestoreService.saveUserData(_userId, {
        'name': _userName,
        'email': _userEmail,
        'stats': {
          'treesPlanted': _treesPlanted,
          'co2Reduced': _co2Reduced,
          'points': _points,
          'waterSaved': _waterSaved,
        },
        'settings': {
          'notifications': _notificationsEnabled,
          'darkMode': _darkModeEnabled,
          'dataSharing': _dataSharingEnabled,
        },
        'profile': {
          'avatarUrl': _avatarUrl,
          'region': _region,
        },
      });
    } catch (e) {
      debugPrint('Error saving to Firestore: $e');
    }
  }

  // ==================== PROFILE MANAGEMENT ====================

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? region,
    String? avatarUrl,
  }) async {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (region != null) _region = region;
    if (avatarUrl != null) _avatarUrl = avatarUrl;

    notifyListeners();
    await saveToFirestore();
  }

  /// Update settings
  Future<void> updateSettings({
    bool? notifications,
    bool? darkMode,
    bool? dataSharing,
  }) async {
    if (notifications != null) _notificationsEnabled = notifications;
    if (darkMode != null) _darkModeEnabled = darkMode;
    if (dataSharing != null) _dataSharingEnabled = dataSharing;

    notifyListeners();
    await saveToFirestore();
  }

  // ==================== STATS MANAGEMENT ====================

  /// Update stats in Firestore
  Future<void> _updateStats() async {
    try {
      await _firestoreService.updateUserStats(_userId, {
        'treesPlanted': _treesPlanted,
        'co2Reduced': _co2Reduced,
        'points': _points,
        'waterSaved': _waterSaved,
      });
    } catch (e) {
      debugPrint('Error updating stats: $e');
    }
  }

  /// Plant a tree
  Future<void> plantTree({String treeType = 'Tree', String? location}) async {
    _treesPlanted++;
    _points += 100;
    _co2Reduced += 25; // Assume 1 tree offsets ~25kg CO2 per year
    _waterSaved += 500; // Assume 1 tree saves ~500L water per year

    notifyListeners();
    await _updateStats();

    // Add activity
    final activity = Activity.treePlanted(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      treeType: treeType,
      location: location ?? _region,
    );
    await addActivity(activity);
  }

  /// Add points
  Future<void> addPoints(int value) async {
    _points += value;
    notifyListeners();
    await _updateStats();
  }

  // ==================== GOALS MANAGEMENT ====================

  /// Listen to goals changes
  void _listenToGoals() {
    _firestoreService.getUserGoalsStream(_userId).listen((goals) {
      _goals = goals;
      notifyListeners();
    });
  }

  /// Add a new goal
  Future<void> addGoal(Goal goal) async {
    try {
      final goalId = await _firestoreService.addGoal(_userId, goal);

      // Add activity
      final activity = Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'New Goal Created',
        description: goal.title,
        location: _region,
        timestamp: DateTime.now(),
        type: 'goal_created',
        metadata: {'goalId': goalId},
      );
      await addActivity(activity);
    } catch (e) {
      debugPrint('Error adding goal: $e');
      rethrow;
    }
  }

  /// Update goal progress
  Future<void> updateGoalProgress(String goalId, double progress) async {
    try {
      await _firestoreService.updateGoal(_userId, goalId, {
        'progress': progress,
      });
    } catch (e) {
      debugPrint('Error updating goal progress: $e');
      rethrow;
    }
  }

  /// Complete a goal
  Future<void> completeGoal(String goalId) async {
    try {
      await _firestoreService.completeGoal(_userId, goalId);

      // Find the goal
      final goal = _goals.firstWhere((g) => g.id == goalId);

      // Add points for completing goal
      _points += 200;
      await _updateStats();

      // Add activity
      final activity = Activity.goalCompleted(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        goalTitle: goal.title,
        location: _region,
      );
      await addActivity(activity);

      notifyListeners();
    } catch (e) {
      debugPrint('Error completing goal: $e');
      rethrow;
    }
  }

  /// Delete a goal
  Future<void> deleteGoal(String goalId) async {
    try {
      await _firestoreService.deleteGoal(_userId, goalId);
    } catch (e) {
      debugPrint('Error deleting goal: $e');
      rethrow;
    }
  }

  // ==================== ACTIVITIES MANAGEMENT ====================

  /// Listen to activities changes
  void _listenToActivities() {
    _firestoreService.getUserActivitiesStream(_userId, limit: 20).listen(
      (activities) {
        _activities = activities;
        notifyListeners();
      },
    );
  }

  /// Add a new activity
  Future<void> addActivity(Activity activity) async {
    try {
      await _firestoreService.addActivity(_userId, activity);
    } catch (e) {
      debugPrint('Error adding activity: $e');
    }
  }

  // ==================== CARBON CALCULATOR ====================

  /// Update carbon footprint
  Future<void> updateCarbonFootprint(
    double footprint, {
    required double transportCO2,
    required double energyCO2,
    required double dietCO2,
    required double travelCO2,
    required Map<String, double> inputs,
  }) async {
    _lastCalculatedFootprint = footprint;

    // Create calculation record
    final calculation = CarbonCalculation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      totalFootprint: footprint,
      transportCO2: transportCO2,
      energyCO2: energyCO2,
      dietCO2: dietCO2,
      travelCO2: travelCO2,
      inputs: inputs,
    );

    _latestCalculation = calculation;

    // Save to Firestore
    try {
      await _firestoreService.saveCarbonCalculation(_userId, calculation);

      // Add activity
      final activity = Activity.calculationDone(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        footprint: footprint,
        location: _region,
      );
      await addActivity(activity);

      // Award points if below average
      if (footprint < 12000) {
        _points += 50;
        await _updateStats();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving carbon calculation: $e');
    }
  }

  // ==================== CLEANUP ====================

  /// Clear all data (for logout)
  void clear() {
    _userId = '';
    _userName = '';
    _userEmail = '';
    _avatarUrl = '';
    _region = '';
    _joinDate = null;
    _co2Reduced = 0.0;
    _treesPlanted = 0;
    _points = 0;
    _waterSaved = 0.0;
    _notificationsEnabled = true;
    _darkModeEnabled = true;
    _dataSharingEnabled = true;
    _goals = [];
    _activities = [];
    _lastCalculatedFootprint = 0.0;
    _latestCalculation = null;
    _isInitialized = false;
    notifyListeners();
  }
}
