import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          icon,
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.textSecondary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.textTertiary,
              fontSize: 11,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
