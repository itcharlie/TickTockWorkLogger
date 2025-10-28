import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt/providers/staff_provider.dart';
import 'package:tt/screens/staff_list/staff_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StaffProvider(),
      child: const TimeTrackingApp(),
    ),
  );
}

class TimeTrackingApp extends StatelessWidget {
  const TimeTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StaffListScreen(),
    );
  }
}