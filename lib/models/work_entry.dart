/// Represents a single work entry for a staff member.
///
/// Records the [hours] worked, [tips] earned, and the [date] of the work.
class WorkEntry {
  /// The number of hours worked in this entry.
  double hours;

  /// The amount of tips earned in this entry.
  double tips;

  /// The date of the work entry (e.g., "2023-10-27").
  String date;

  WorkEntry({required this.hours, required this.tips, required this.date});
}
