import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'recent_activity_item.dart';

class RecentActivityCard extends StatelessWidget {
  final List<RecentActivity> activities;

  const RecentActivityCard({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.history, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Recent Activity / Hoạt động gần đây',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            return RecentActivityItem(
              activity: activity,
              isLast: index == activities.length - 1,
            )
                .animate(delay: Duration(milliseconds: 100 * index))
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0);
          }),
        ],
      ),
    );
  }
}

class RecentActivity {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  RecentActivity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}
