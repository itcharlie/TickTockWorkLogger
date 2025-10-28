import 'package:flutter/material.dart';
import 'package:tt/models/staff_member.dart';
import 'package:tt/models/work_entry.dart';

class StaffProvider extends ChangeNotifier {
  final List<StaffMember> _staff = [];

  List<StaffMember> get staff => _staff;

  void addStaff(String firstName,String lastName) {
    _staff.add(StaffMember(firstName: firstName, lastName: lastName));
    notifyListeners();
  }

  void editStaff(StaffMember member, String newFirstName, String newLastName) {
    member.firstName = newFirstName;
    member.lastName = newLastName;
    notifyListeners();
  }

  void deleteStaff(StaffMember member) {
    _staff.remove(member);
    notifyListeners();
  }

  void recordWork(StaffMember member, double hours, double tips, String date) {
    member.workEntries.add(WorkEntry(hours: hours, tips: tips, date: date));
    notifyListeners();
  }

  Map<String, dynamic> generateSummary() {
    double totalHours = 0;
    double totalTips = 0;

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
