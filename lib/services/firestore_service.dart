import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';
import '../models/activity.dart';
import '../models/carbon_calculation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER DATA ====================

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Save/Update user profile data
  Future<void> saveUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).set(
            data,
            SetOptions(merge: true),
          );
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  /// Update user stats
  Future<void> updateUserStats(
      String userId, Map<String, dynamic> stats) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'stats': stats,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user stats: $e');
      rethrow;
    }
  }

  // ==================== GOALS ====================

  /// Get user goals as a stream
  Stream<List<Goal>> getUserGoalsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Goal.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    });
  }

  /// Get user goals (one-time fetch)
  Future<List<Goal>> getUserGoals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Goal.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      print('Error getting user goals: $e');
      return [];
    }
  }

  /// Add a new goal
  Future<String> addGoal(String userId, Goal goal) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .add(goal.toJson());
      return docRef.id;
    } catch (e) {
      print('Error adding goal: $e');
      rethrow;
    }
  }

  /// Update a goal
  Future<void> updateGoal(
      String userId, String goalId, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(goalId)
          .update(updates);
    } catch (e) {
      print('Error updating goal: $e');
      rethrow;
    }
  }

  /// Delete a goal
  Future<void> deleteGoal(String userId, String goalId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(goalId)
          .delete();
    } catch (e) {
      print('Error deleting goal: $e');
      rethrow;
    }
  }

  /// Complete a goal
  Future<void> completeGoal(String userId, String goalId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(goalId)
          .update({
        'completed': true,
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error completing goal: $e');
      rethrow;
    }
  }

  // ==================== ACTIVITIES ====================

  /// Get user activities as a stream
  Stream<List<Activity>> getUserActivitiesStream(String userId,
      {int limit = 10}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Activity.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    });
  }

  /// Get user activities (one-time fetch)
  Future<List<Activity>> getUserActivities(String userId,
      {int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('activities')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        return Activity.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      print('Error getting user activities: $e');
      return [];
    }
  }

  /// Add a new activity
  Future<void> addActivity(String userId, Activity activity) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('activities')
          .add(activity.toJson());
    } catch (e) {
      print('Error adding activity: $e');
      rethrow;
    }
  }

  // ==================== CARBON CALCULATIONS ====================

  /// Save a carbon calculation
  Future<void> saveCarbonCalculation(
      String userId, CarbonCalculation calculation) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('calculations')
          .add(calculation.toJson());
    } catch (e) {
      print('Error saving carbon calculation: $e');
      rethrow;
    }
  }

  /// Get calculation history
  Future<List<CarbonCalculation>> getCalculationHistory(String userId,
      {int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('calculations')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        return CarbonCalculation.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      print('Error getting calculation history: $e');
      return [];
    }
  }

  /// Get the latest calculation
  Future<CarbonCalculation?> getLatestCalculation(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('calculations')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return CarbonCalculation.fromJson(
          {...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
    } catch (e) {
      print('Error getting latest calculation: $e');
      return null;
    }
  }

  // ==================== INITIALIZATION ====================

  /// Initialize user document with default data
  Future<void> initializeUserDocument(
    String userId,
    String email,
    String name,
  ) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userId).set({
          'email': email,
          'name': name,
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
            'avatarUrl': '',
            'region': '',
            'goalType': '',
          },
        });
      }
    } catch (e) {
      print('Error initializing user document: $e');
      rethrow;
    }
  }
}
