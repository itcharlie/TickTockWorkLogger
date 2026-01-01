import 'package:flutter/material.dart';
import 'package:tt/models/staff_member.dart';
import 'package:tt/models/work_entry.dart';

/// [StaffProvider] manages the state of the application, including the list of
/// staff members and their associated work entries.
///
/// It provides methods to add, edit, and delete staff, as well as recording
/// work hours and tips for each member.
class StaffProvider extends ChangeNotifier {
  /// The internal list of staff members.
  final List<StaffMember> _staff = [];

  /// Returns an unmodifiable view of the staff list.
  List<StaffMember> get staff => List.unmodifiable(_staff);

  /// Adds a new [StaffMember] to the list.
  ///
  /// Takes [firstName] and [lastName] and notifies listeners of the change.
  void addStaff(String firstName, String lastName) {
    _staff.add(StaffMember(firstName: firstName, lastName: lastName));
    notifyListeners();
  }

  /// Updates an existing [StaffMember]'s information.
  ///
  /// Modifies the [member]'s [newFirstName] and [newLastName] and notifies listeners.
  void editStaff(StaffMember member, String newFirstName, String newLastName) {
    member.firstName = newFirstName;
    member.lastName = newLastName;
    notifyListeners();
  }

  /// Removes a [StaffMember] from the list.
  ///
  /// Notifies listeners after removal.
  void deleteStaff(StaffMember member) {
    _staff.remove(member);
    notifyListeners();
  }

  /// Records a new [WorkEntry] for a specific [member].
  ///
  /// Takes the number of [hours] worked, [tips] earned, and the [date] of the entry.
  /// The entry is added to the member's list of work entries.
  void recordWork(StaffMember member, double hours, double tips, String date) {
    member.workEntries.add(WorkEntry(hours: hours, tips: tips, date: date));
    notifyListeners();
  }

  /// Generates a summary report of all work performed by all staff members.
  ///
  /// Returns a [Map] containing:
  /// - 'totalHours': The sum of hours worked by all staff.
  /// - 'totalTips': The sum of tips earned by all staff.
  /// - 'staffCount': The total number of staff members.
  Map<String, dynamic> generateSummary() {
    double totalHours = 0;
    double totalTips = 0;

    // Iterates through each staff member to aggregate their total hours and tips.
    for (var member in _staff) {
      totalHours += member.totalHours;
      totalTips += member.totalTips;
    }

    return {
      'totalHours': totalHours,
      'totalTips': totalTips,
      'staffCount': _staff.length,
    };
  }
}
