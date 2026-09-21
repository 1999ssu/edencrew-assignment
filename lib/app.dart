import 'package:edencrew_assignment_starter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'theme/theme.dart';

class EdencrewAssignmentApp extends StatelessWidget {
  const EdencrewAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '이든크루 평가 과제',
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
