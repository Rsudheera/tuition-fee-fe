import 'package:flutter/material.dart';

class PendingPaymentsScreen extends StatelessWidget {
  const PendingPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is just a placeholder. You would implement the actual pending payments list here
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Payments')),
      body: ListView.builder(
        itemCount: 8,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Icon(Icons.pending, color: Colors.orange.shade800),
              ),
              title: Text('Student ${index + 1}'),
              subtitle: Text(
                'Class: Science Grade ${10 + (index % 3)}\nDue: LKR ${2500 + (index * 500)}',
              ),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Mark Paid'),
              ),
            ),
          );
        },
      ),
    );
  }
}
