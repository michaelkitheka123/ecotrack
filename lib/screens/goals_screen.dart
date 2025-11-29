import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/user_data_provider.dart';
import '../models/goal.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final activeGoals = userData.activeGoals;
    final completedGoals = userData.completedGoals;

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
                        tabs: [
                          Tab(text: 'Active (${activeGoals.length})'),
                          Tab(text: 'Completed (${completedGoals.length})'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildGoalsList(activeGoals, false),
                            _buildGoalsList(completedGoals, true),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
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
            'My Goals',
            style: AppTheme.headlineLarge.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList(List<Goal> goals, bool isCompleted) {
    if (goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle_outline : Icons.flag_outlined,
              size: 64,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted ? 'No completed goals yet!' : 'No active goals yet!',
              style: AppTheme.bodyLarge.copyWith(color: Colors.white54),
            ),
            const SizedBox(height: 8),
            if (!isCompleted)
              Text(
                'Tap + to create your first goal',
                style: AppTheme.bodyMedium,
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key(goal.id),
            direction: isCompleted
                ? DismissDirection.endToStart
                : DismissDirection.horizontal,
            background: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.check, color: Colors.white),
            ),
            secondaryBackground: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd && !isCompleted) {
                // Complete goal
                await Provider.of<UserDataProvider>(context, listen: false)
                    .completeGoal(goal.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Goal "${goal.title}" completed! +200 points'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                }
                return false;
              } else if (direction == DismissDirection.endToStart) {
                // Delete goal
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppTheme.surfaceDark,
                    title: Text('Delete Goal', style: AppTheme.headlineLarge),
                    content: Text(
                      'Are you sure you want to delete "${goal.title}"?',
                      style: AppTheme.bodyLarge,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              }
              return false;
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                Provider.of<UserDataProvider>(context, listen: false)
                    .deleteGoal(goal.id);
              }
            },
            child: GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          goal.title,
                          style: AppTheme.titleLarge.copyWith(
                            color: isCompleted
                                ? AppTheme.primaryGreen
                                : Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          goal.category,
                          style: AppTheme.bodyMedium.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(goal.description, style: AppTheme.bodyMedium),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.progress / goal.target,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation(
                        isCompleted ? AppTheme.primaryGreen : Colors.blueAccent,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${goal.progress.toStringAsFixed(0)}/${goal.target.toStringAsFixed(0)} ${goal.unit}',
                        style: AppTheme.bodyLarge
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (!isCompleted)
                        Text(
                          goal.isOverdue
                              ? 'Overdue!'
                              : '${goal.daysRemaining} days left',
                          style: AppTheme.bodyMedium.copyWith(
                            color: goal.isOverdue
                                ? Colors.redAccent
                                : Colors.white54,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 100).ms).slideX(),
        );
      },
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final targetController = TextEditingController();
    String selectedCategory = 'Transportation';
    String selectedUnit = 'times';
    int selectedDays = 30;

    final categories = [
      'Transportation',
      'Home Energy',
      'Diet',
      'Community',
      'Waste Reduction',
      'Water Conservation',
    ];

    final units = ['times', 'days', 'kg', '% reduction', 'trees', 'items'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: Text('Create New Goal', style: AppTheme.headlineLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Goal Title',
                    prefixIcon: Icon(Icons.flag),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Target',
                    prefixIcon: Icon(Icons.track_changes),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedCategory = value!);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedUnit,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    prefixIcon: Icon(Icons.straighten),
                  ),
                  items: units.map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedUnit = value!);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedDays,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Deadline',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  items: [7, 14, 30, 60, 90].map((days) {
                    return DropdownMenuItem(
                      value: days,
                      child: Text('$days days'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedDays = value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    targetController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill in all required fields')),
                  );
                  return;
                }

                final newGoal = Goal(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  progress: 0,
                  target: double.parse(targetController.text),
                  unit: selectedUnit,
                  category: selectedCategory,
                  deadline: DateTime.now().add(Duration(days: selectedDays)),
                  createdAt: DateTime.now(),
                );

                await Provider.of<UserDataProvider>(context, listen: false)
                    .addGoal(newGoal);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Goal created successfully!'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                }
              },
              child: const Text('Create',
                  style: TextStyle(color: AppTheme.primaryGreen)),
            ),
          ],
        ),
      ),
    );
  }
}
