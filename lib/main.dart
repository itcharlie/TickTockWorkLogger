import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StaffProvider(),
      child: const TimeTrackingApp(),
    ),
  );
}

class TimeTrackingApp extends StatelessWidget {
  const TimeTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StaffListScreen(),
    );
  }
}

class StaffMember {
  String name;
  double totalHours;
  double totalTips;

  StaffMember({required this.first_name, this.last_name, this.totalHours = 0, this.totalTips = 0});
}

class StaffProvider extends ChangeNotifier {
  final List<StaffMember> _staff = [];

  List<StaffMember> get staff => _staff;

  void addStaff(String first_name, String last_name) {
    _staff.add(StaffMember(first_name: first_name, last_name: last_name));
    notifyListeners();
  }

  void recordWork(StaffMember member, double hours, double tips) {
    member.totalHours += hours;
    member.totalTips += tips;
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

class StaffListScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<StaffProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Staff Tracker'), actions: [
        IconButton(
          icon: const Icon(Icons.summarize),
          onPressed: () {
            var summary = provider.generateSummary();
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Weekly Summary'),
                content: Text(
                  'Staff: ${summary['staffCount']}\n'
                  'Total Hours: ${summary['totalHours']}\n'
                  'Total Tips: \$${summary['totalTips'].toStringAsFixed(2)}',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                ],
              ),
            );
          },
        )
      ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Staff Name'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      provider.addStaff(_nameController.text);
                      _nameController.clear();
                    }
                  },
                  child: const Text('Add'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.staff.length,
              itemBuilder: (context, index) {
                var member = provider.staff[index];
                return ListTile(
                  title: Text(member.name),
                  subtitle: Text('Hours: ${member.totalHours}, Tips: \$${member.totalTips.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _showRecordDialog(context, provider, member);
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showRecordDialog(BuildContext context, StaffProvider provider, StaffMember member) {
    final hoursController = TextEditingController();
    final tipsController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Record for ${member.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Hours Worked'),
            ),
            TextField(
              controller: tipsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tips Earned'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              double hours = double.tryParse(hoursController.text) ?? 0;
              double tips = double.tryParse(tipsController.text) ?? 0;
              provider.recordWork(member, hours, tips);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
