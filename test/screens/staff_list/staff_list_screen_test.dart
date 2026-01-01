import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:tt/providers/staff_provider.dart';
import 'package:tt/screens/staff_list/staff_list_screen.dart';
import 'package:tt/screens/work_entries/work_entries_screen.dart';

void main() {
  group('StaffListScreen Widget Tests', () {
    late StaffProvider staffProvider;

    // Helper function to pump the StaffListScreen with a StaffProvider
    Future<void> pumpStaffListScreen(WidgetTester tester, StaffProvider provider) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<StaffProvider>.value(
          value: provider,
          child: MaterialApp(
            home: StaffListScreen(),
          ),
        ),
      );
    }

    setUp(() {
      staffProvider = StaffProvider();
    });

    testWidgets('StaffListScreen displays title and initial empty state', (WidgetTester tester) async {
      await pumpStaffListScreen(tester, staffProvider);

      expect(find.text('Employee Worklog'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('Adding a staff member updates the list', (WidgetTester tester) async {
      await pumpStaffListScreen(tester, staffProvider);

      await tester.enterText(find.byKey(const Key('addFirstNameField')), 'Alice');
      await tester.enterText(find.byKey(const Key('addLastNameField')), 'Smith');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();

      expect(find.text('Alice Smith'), findsOneWidget);
      expect(staffProvider.staff.length, 1);
    });

    testWidgets('Editing a staff member updates their details', (WidgetTester tester) async {
      staffProvider.addStaff('Alice', 'Smith');
      await pumpStaffListScreen(tester, staffProvider);

      expect(find.text('Alice Smith'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle(); // Wait for dialog to appear

      expect(find.text('Edit Staff Member'), findsOneWidget);

      // Find text fields within the AlertDialog
      await tester.enterText(find.byKey(const Key('editFirstNameField')), 'Alicia');
      await tester.enterText(find.byKey(const Key('editLastNameField')), 'Jones');
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle(); // Wait for dialog to close and list to update

      expect(find.text('Alicia Jones'), findsOneWidget);
      expect(find.text('Alice Smith'), findsNothing);
    });

    testWidgets('Deleting a staff member removes them from the list', (WidgetTester tester) async {
      staffProvider.addStaff('Alice', 'Smith');
      await pumpStaffListScreen(tester, staffProvider);

      expect(find.text('Alice Smith'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Alice Smith'), findsNothing);
      expect(staffProvider.staff, isEmpty);
    });

    testWidgets('Tapping on a staff member navigates to WorkEntriesScreen', (WidgetTester tester) async {
      staffProvider.addStaff('Alice', 'Smith');
      await pumpStaffListScreen(tester, staffProvider);

      await tester.tap(find.text('Alice Smith'));
      await tester.pumpAndSettle();

      expect(find.byType(WorkEntriesScreen), findsOneWidget);
      expect(find.text('Work Entries for Alice Smith'), findsOneWidget);
    });

    testWidgets('Record work dialog appears and saves entry', (WidgetTester tester) async {
      staffProvider.addStaff('Alice', 'Smith');
      await pumpStaffListScreen(tester, staffProvider);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(); // Wait for dialog to appear

      expect(find.text('Record for Alice Smith'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextField, 'Hours Worked'), '8');
      await tester.enterText(find.widgetWithText(TextField, 'Tips Earned'), '20');
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle(); // Wait for dialog to close and list to update

      final member = staffProvider.staff[0];
      expect(member.workEntries.length, 1);
      expect(member.totalHours, 8.0);
      expect(member.totalTips, 20.0);
    });

    testWidgets('Summary dialog appears and displays correct data', (WidgetTester tester) async {
      staffProvider.addStaff('Alice', 'Smith');
      staffProvider.recordWork(staffProvider.staff[0], 8.0, 10.0, '2023-01-01');
      staffProvider.addStaff('Bob', 'Johnson');
      staffProvider.recordWork(staffProvider.staff[1], 7.0, 5.0, '2023-01-01');

      await pumpStaffListScreen(tester, staffProvider);

      await tester.tap(find.byIcon(Icons.summarize));
      await tester.pumpAndSettle(); // Wait for dialog to appear

      expect(find.text('Weekly Summary'), findsOneWidget);
      expect(find.text('Staff: 2\nTotal Hours: 15.0\nTotal Tips: \$15.00'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle(); // Dismiss dialog
    });
  });
}