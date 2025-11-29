class Goal {
  final String id;
  final String title;
  final String description;
  final double progress;
  final double target;
  final String unit;
  final String category;
  final DateTime deadline;
  final DateTime createdAt;
  final bool completed;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    required this.unit,
    required this.category,
    required this.deadline,
    required this.createdAt,
    this.completed = false,
  });

  // Create a copy with updated fields
  Goal copyWith({
    String? id,
    String? title,
    String? description,
    double? progress,
    double? target,
    String? unit,
    String? category,
    DateTime? deadline,
    DateTime? createdAt,
    bool? completed,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      completed: completed ?? this.completed,
    );
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'progress': progress,
      'target': target,
      'unit': unit,
      'category': category,
      'deadline': deadline.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completed': completed,
    };
  }

  // Create from JSON from Firestore
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      progress: (json['progress'] as num).toDouble(),
      target: (json['target'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completed: json['completed'] as bool? ?? false,
    );
  }

  // Calculate progress percentage
  double get progressPercentage => (progress / target * 100).clamp(0, 100);

  // Check if goal is overdue
  bool get isOverdue => !completed && DateTime.now().isAfter(deadline);

  // Get days remaining
  int get daysRemaining => deadline.difference(DateTime.now()).inDays;
}
