import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<Map<String, dynamic>> _dummyAttendanceData = [
    {
      'date': 'Sept 5, 2025',
      'className': 'Physics Grade 12',
      'totalStudents': 15,
      'present': 12,
      'absent': 3,
    },
    {
      'date': 'Sept 4, 2025',
      'className': 'Chemistry Grade 11',
      'totalStudents': 18,
      'present': 16,
      'absent': 2,
    },
    {
      'date': 'Sept 3, 2025',
      'className': 'Mathematics Grade 10',
      'totalStudents': 20,
      'present': 17,
      'absent': 3,
    },
    {
      'date': 'Sept 2, 2025',
      'className': 'Biology Grade 12',
      'totalStudents': 14,
      'present': 14,
      'absent': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter attendance records
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter functionality coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search classes',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Search functionality will be implemented later
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Calendar view will be implemented later
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Calendar view coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Calendar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dummyAttendanceData.length,
              itemBuilder: (context, index) {
                final item = _dummyAttendanceData[index];
                final attendanceRate =
                    (item['present'] / item['totalStudents'] * 100).round();

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(item['className']),
                    subtitle: Text('Date: ${item['date']}'),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Attendance: $attendanceRate%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: attendanceRate > 90
                                ? Colors.green
                                : attendanceRate > 70
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                        Text(
                          'Present: ${item['present']}/${item['totalStudents']}',
                        ),
                      ],
                    ),
                    onTap: () {
                      // Show detailed attendance for this class
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Detailed attendance for ${item['className']} coming soon',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Add new attendance record
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add attendance record functionality coming soon'),
            ),
          );
        },
      ),
    );
  }
}
