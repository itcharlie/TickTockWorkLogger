import 'package:flutter_test/flutter_test.dart';
import 'package:tt/models/staff_member.dart';
import 'package:tt/models/work_entry.dart';

void main() {
  group('StaffMember', () {
    test('totalHours calculates correctly with multiple entries', () {
      final staffMember = StaffMember(firstName: 'John', lastName: 'Doe');
      staffMember.workEntries.add(WorkEntry(hours: 8.0, tips: 10.0, date: '2023-01-01'));
      staffMember.workEntries.add(WorkEntry(hours: 7.5, tips: 15.0, date: '2023-01-02'));
      staffMember.workEntries.add(WorkEntry(hours: 6.0, tips: 5.0, date: '2023-01-03'));

      expect(staffMember.totalHours, equals(21.5));
    });

    test('totalTips calculates correctly with multiple entries', () {
      final staffMember = StaffMember(firstName: 'John', lastName: 'Doe');
      staffMember.workEntries.add(WorkEntry(hours: 8.0, tips: 10.0, date: '2023-01-01'));
      staffMember.workEntries.add(WorkEntry(hours: 7.5, tips: 15.0, date: '2023-01-02'));
      staffMember.workEntries.add(WorkEntry(hours: 6.0, tips: 5.0, date: '2023-01-03'));

      expect(staffMember.totalTips, equals(30.0));
    });

    test('totalHours is zero when no work entries', () {
      final staffMember = StaffMember(firstName: 'Jane', lastName: 'Smith');
      expect(staffMember.totalHours, equals(0.0));
    });

    test('totalTips is zero when no work entries', () {
      final staffMember = StaffMember(firstName: 'Jane', lastName: 'Smith');
      expect(staffMember.totalTips, equals(0.0));
    });

    test('totalHours calculates correctly with a single entry', () {
      final staffMember = StaffMember(firstName: 'Alice', lastName: 'Doe');
      staffMember.workEntries.add(WorkEntry(hours: 9.0, tips: 20.0, date: '2023-01-01'));
      expect(staffMember.totalHours, equals(9.0));
    });

    test('totalTips calculates correctly with a single entry', () {
      final staffMember = StaffMember(firstName: 'Alice', lastName: 'Doe');
      staffMember.workEntries.add(WorkEntry(hours: 9.0, tips: 20.0, date: '2023-01-01'));
      expect(staffMember.totalTips, equals(20.0));
    });
  });
}