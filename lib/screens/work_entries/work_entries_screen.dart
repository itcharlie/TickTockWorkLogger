import 'package:flutter/material.dart';
import 'package:tt/models/staff_member.dart';

class WorkEntriesScreen extends StatelessWidget {
  final StaffMember member;

  const WorkEntriesScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${member.firstName} ${member.lastName}')),
      body: ListView.builder(
        itemCount: member.workEntries.length,
        itemBuilder: (context, index) {
          var entry = member.workEntries[index];
          return ListTile(
            title: Text('Date: ${entry.date}'),
            subtitle: Text('Hours: ${entry.hours}, Tips: \$${entry.tips.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
