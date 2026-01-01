import 'package:flutter_test/flutter_test.dart';


import 'package:tt/providers/staff_provider.dart';

void main() {
  group('StaffProvider', () {
    late StaffProvider staffProvider;

    setUp(() {
      staffProvider = StaffProvider();
    });

    test('staff list is initially empty', () {
      expect(staffProvider.staff, isEmpty);
    });

    test('addStaff adds a new staff member', () {
      staffProvider.addStaff('Alice', 'Smith');
      expect(staffProvider.staff.length, 1);
      expect(staffProvider.staff[0].firstName, 'Alice');
      expect(staffProvider.staff[0].lastName, 'Smith');
    });

    test('editStaff updates an existing staff member', () {
      staffProvider.addStaff('Alice', 'Smith');
      final member = staffProvider.staff[0];
      staffProvider.editStaff(member, 'Alicia', 'Jones');

      expect(member.firstName, 'Alicia');
      expect(member.lastName, 'Jones');
    });

    test('deleteStaff removes a staff member', () {
      staffProvider.addStaff('Alice', 'Smith');
      final member = staffProvider.staff[0];
      staffProvider.deleteStaff(member);

      expect(staffProvider.staff, isEmpty);
    });

    test('recordWork adds a work entry to a staff member', () {
      staffProvider.addStaff('Alice', 'Smith');
      final member = staffProvider.staff[0];

      staffProvider.recordWork(member, 8.0, 15.0, '2023-01-01');

      expect(member.workEntries.length, 1);
      expect(member.workEntries[0].hours, 8.0);
      expect(member.workEntries[0].tips, 15.0);
    });

    test('generateSummary calculates total hours and tips correctly', () {
      staffProvider.addStaff('Alice', 'Smith');
      final alice = staffProvider.staff[0];
      staffProvider.recordWork(alice, 8.0, 10.0, '2023-01-01');
      staffProvider.recordWork(alice, 7.0, 15.0, '2023-01-02');

      staffProvider.addStaff('Bob', 'Johnson');
      final bob = staffProvider.staff[1];
      staffProvider.recordWork(bob, 6.0, 5.0, '2023-01-01');

      final summary = staffProvider.generateSummary();

      expect(summary['totalHours'], equals(21.0)); // 8+7+6
      expect(summary['totalTips'], equals(30.0)); // 10+15+5
      expect(summary['staffCount'], equals(2));
    });

    test('generateSummary returns zero for empty staff list', () {
      final summary = staffProvider.generateSummary();

      expect(summary['totalHours'], equals(0.0));
      expect(summary['totalTips'], equals(0.0));
      expect(summary['staffCount'], equals(0));
    });

    test('notifies listeners when addStaff is called', () {
      var listenerCalled = false;
      staffProvider.addListener(() {
        listenerCalled = true;
      });
      staffProvider.addStaff('Test', 'User');
      expect(listenerCalled, isTrue);
    });

    test('notifies listeners when editStaff is called', () {
      staffProvider.addStaff('Original', 'Name');
      var listenerCalled = false;
      staffProvider.addListener(() {
        listenerCalled = true;
      });
      staffProvider.editStaff(staffProvider.staff[0], 'Edited', 'Name');
      expect(listenerCalled, isTrue);
    });

    test('notifies listeners when deleteStaff is called', () {
      staffProvider.addStaff('To', 'Delete');
      var listenerCalled = false;
      staffProvider.addListener(() {
        listenerCalled = true;
      });
      staffProvider.deleteStaff(staffProvider.staff[0]);
      expect(listenerCalled, isTrue);
    });

    test('notifies listeners when recordWork is called', () {
      staffProvider.addStaff('Work', 'Person');
      var listenerCalled = false;
      staffProvider.addListener(() {
        listenerCalled = true;
      });
      staffProvider.recordWork(staffProvider.staff[0], 5.0, 5.0, '2023-01-01');
      expect(listenerCalled, isTrue);
    });
  });
}