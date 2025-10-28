import 'package:tt/models/work_entry.dart';

class StaffMember {
  String firstName;
  String lastName;
  List<WorkEntry> workEntries = [];

  StaffMember({required this.firstName, required this.lastName});

  double get totalHours => workEntries.fold(0, (sum, entry) => sum + entry.hours);
  double get totalTips => workEntries.fold(0, (sum, entry) => sum + entry.tips);
}
