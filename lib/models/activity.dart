class Activity {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime timestamp;
  final String
      type; // 'tree_planted', 'goal_completed', 'calculation_done', 'goal_created'
  final Map<String, dynamic> metadata;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.timestamp,
    required this.type,
    this.metadata = const {},
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'metadata': metadata,
    };
  }

  // Create from JSON from Firestore
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  // Get relative time string (e.g., "2 days ago")
  String get relativeTime {
    final difference = DateTime.now().difference(timestamp);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  // Factory methods for common activity types
  factory Activity.treePlanted({
    required String id,
    required String treeType,
    required String location,
    DateTime? timestamp,
  }) {
    return Activity(
      id: id,
      title: 'Planted a $treeType Tree',
      description: 'Successfully planted a tree',
      location: location,
      timestamp: timestamp ?? DateTime.now(),
      type: 'tree_planted',
      metadata: {'treeType': treeType},
    );
  }

  factory Activity.goalCompleted({
    required String id,
    required String goalTitle,
    required String location,
    DateTime? timestamp,
  }) {
    return Activity(
      id: id,
      title: 'Completed Goal',
      description: goalTitle,
      location: location,
      timestamp: timestamp ?? DateTime.now(),
      type: 'goal_completed',
      metadata: {'goalTitle': goalTitle},
    );
  }

  factory Activity.calculationDone({
    required String id,
    required double footprint,
    required String location,
    DateTime? timestamp,
  }) {
    return Activity(
      id: id,
      title: 'Carbon Footprint Calculated',
      description: '${footprint.toStringAsFixed(1)} kg CO₂/year',
      location: location,
      timestamp: timestamp ?? DateTime.now(),
      type: 'calculation_done',
      metadata: {'footprint': footprint},
    );
  }
}
