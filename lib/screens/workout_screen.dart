import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  // Sample workout data
  final List<Map<String, dynamic>> workouts = const [
    {
      'title': 'Yoga',
      'exercises': 3,
      'duration': '12 Minutes',
      'progress': 0,
      'total': 3,
      'color': Color(0xFF8B5CF6), // Purple
      'image': '🧘‍♀️',
    },
    {
      'title': 'Pilates',
      'exercises': 4,
      'duration': '14 Minutes',
      'progress': 0,
      'total': 4,
      'color': Color(0xFF8B5CF6), // Purple
      'image': '🤸‍♀️',
    },
    {
      'title': 'Full body',
      'exercises': 3,
      'duration': '12 Minutes',
      'progress': 0,
      'total': 3,
      'color': Color(0xFF06B6D4), // Cyan
      'image': '💪',
    },
    {
      'title': 'Stretching',
      'exercises': 5,
      'duration': '16 Minutes',
      'progress': 0,
      'total': 5,
      'color': Color(0xFFEC4899), // Pink
      'image': '🤸‍♀️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: Row(
                children: [
                  const Text(
                    'Workouts',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Workout Cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return _buildWorkoutCard(workout);
                },
              ),
            ),

            // Bottom Navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side - Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${workout['exercises']} Exercises',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  workout['duration'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '${workout['progress']}/${workout['total']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: workout['progress'] / workout['total'],
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          workout['color'],
                        ),
                        minHeight: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right side - Image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: workout['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                workout['image'],
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
          _buildNavItem(Icons.fitness_center, 'Workouts', true),
          _buildNavItem(Icons.settings, 'Settings', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF8B5CF6) : Colors.grey[400],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF8B5CF6) : Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
