import 'package:tt/models/work_entry.dart';
import 'package:uuid/uuid.dart';

/// Represents a staff member in the system.
///
/// Contains personal information and a list of work entries recorded for this member.
class StaffMember {
  /// Unique identifier for the staff member.
  final String id;

  /// The first name of the staff member.
  String firstName;

  /// The last name of the staff member.
  String lastName;

  /// A list of [WorkEntry] objects representing the member's work history.
  List<WorkEntry> workEntries = [];

  StaffMember({required this.firstName, required this.lastName}) : id = const Uuid().v4();

  /// Calculates the total hours worked by summing all work entries.
  double get totalHours => workEntries.fold(0, (sum, entry) => sum + entry.hours);

  /// Calculates the total tips earned by summing all work entries.
  double get totalTips => workEntries.fold(0, (sum, entry) => sum + entry.tips);
}
