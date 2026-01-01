import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tt/models/staff_member.dart';
import 'package:tt/models/work_entry.dart';
import 'package:tt/providers/staff_provider.dart';
import 'package:tt/screens/work_entries/work_entries_screen.dart';

void main() {
  group('WorkEntriesScreen Widget Tests', () {
    late StaffProvider staffProvider;
    late StaffMember staffMember;

    // Helper function to pump the WorkEntriesScreen with a StaffProvider
    Future<void> pumpWorkEntriesScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<StaffProvider>.value(
          value: staffProvider,
          child: MaterialApp(
            home: WorkEntriesScreen(member: staffMember),
          ),
        ),
      );
    }

    setUp(() {
      staffProvider = StaffProvider();
      staffProvider.addStaff('Alice', 'Smith');
      staffMember = staffProvider.staff[0];
    });

    testWidgets('WorkEntriesScreen displays title and staff member name', (WidgetTester tester) async {
      await pumpWorkEntriesScreen(tester);

      expect(find.text('Work Entries for Alice Smith'), findsOneWidget);
    });

    testWidgets('WorkEntriesScreen displays work entries correctly', (WidgetTester tester) async {
      staffMember.workEntries.add(WorkEntry(hours: 8.0, tips: 10.0, date: '2023-01-01'));
      staffMember.workEntries.add(WorkEntry(hours: 7.5, tips: 15.0, date: '2023-01-02'));

      await pumpWorkEntriesScreen(tester);

      expect(find.text('Date: 2023-01-01'), findsOneWidget);
      expect(find.text('Hours: 8.0, Tips: \$10.00'), findsOneWidget);
      expect(find.text('Date: 2023-01-02'), findsOneWidget);
      expect(find.text('Hours: 7.5, Tips: \$15.00'), findsOneWidget);
    });


  });
}