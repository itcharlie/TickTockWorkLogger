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
  String firstName;
  String lastName;
  double totalHours;
  double totalTips;
  String date;

  StaffMember({required this.firstName, required this.lastName, this.totalHours = 0, this.totalTips = 0 , this.date =""});
}

class StaffProvider extends ChangeNotifier {
  final List<StaffMember> _staff = [];

  List<StaffMember> get staff => _staff;

  void addStaff(String firstName,String lastName) {
    _staff.add(StaffMember(firstName: firstName, lastName: lastName));
    notifyListeners();
  }

  void recordWork(StaffMember member, double hours, double tips, String date) {
    member.totalHours += hours;
    member.totalTips += tips;
    member.date = date;
    notifyListeners();
  }

  Map<String, dynamic> generateSummary() {
    double totalHours = 0;
    double totalTips = 0;
    String date = "";

    for (var member in _staff) {
      totalHours += member.totalHours;
      totalTips += member.totalTips;
      date = member.date;
    }

    return {
      'totalHours': totalHours,
      'totalTips': totalTips,
      'date': date,
      'staffCount': _staff.length,
    };
  }
}

class StaffListScreen extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<StaffProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Worklog'), actions: [
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
                  'Total Tips: \$${summary['totalTips'].toStringAsFixed(2)}'
                  'Date: ${summary['date']}\n',
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
                Expanded(child:  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  )),
                Expanded(child:TextField(
                    controller:_lastNameController,
                    decoration:const InputDecoration(labelText: 'Last Name')
                 )),
                  
                ElevatedButton(
                  onPressed: () {
                    if (_firstNameController.text.isNotEmpty || _lastNameController.text.isNotEmpty ) {
                      provider.addStaff(_firstNameController.text,_lastNameController.text );
                      _firstNameController.clear();
                      _lastNameController.clear();
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
                  title: Text("${member.firstName}  ${member.lastName} "),
                  subtitle: Text('Hours: ${member.totalHours}, Tips: \$${member.totalTips.toStringAsFixed(2)} Date: ${member.date}'),
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
    final dateController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Record for ${member.firstName} ${member.lastName}'),
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
            TextField(
              controller: dateController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(labelText: 'Date Worked'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              double hours = double.tryParse(hoursController.text) ?? 0;
              double tips = double.tryParse(tipsController.text) ?? 0;
              String date = dateController.text;
              provider.recordWork(member, hours, tips, date);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
