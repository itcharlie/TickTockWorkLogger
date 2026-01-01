import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt/models/staff_member.dart';
import 'package:tt/providers/staff_provider.dart';
import 'package:tt/screens/work_entries/work_entries_screen.dart';

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
                ),
 
              ],
            ),
          ),
          Expanded(
            child: Consumer<StaffProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.staff.length,
                  itemBuilder: (context, index) {
                    var member = provider.staff[index];
                    return ListTile(
                      title: Text("${member.firstName}  ${member.lastName} "),
                      subtitle: Text('Hours: ${member.totalHours}, Tips: \$${member.totalTips.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkEntriesScreen(member: member),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _showRecordDialog(context, provider, member);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(context, provider, member);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.deleteStaff(member);
                            },
                          ),
                        ],
                      ),
                    );
                  },
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
    DateTime selectedDate = DateTime.now();

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
            ListTile(
              title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate) {
                  selectedDate = picked;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              double hours = double.tryParse(hoursController.text) ?? 0;
              double tips = double.tryParse(tipsController.text) ?? 0;
              String date = "${selectedDate.toLocal()}".split(' ')[0];
              provider.recordWork(member, hours, tips, date);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, StaffProvider provider, StaffMember member) {
    final firstNameController = TextEditingController(text: member.firstName);
    final lastNameController = TextEditingController(text: member.lastName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Staff Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.editStaff(member, firstNameController.text, lastNameController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
