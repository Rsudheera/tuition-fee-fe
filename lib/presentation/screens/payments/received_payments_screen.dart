import 'package:flutter/material.dart';

class ReceivedPaymentsScreen extends StatelessWidget {
  const ReceivedPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is just a placeholder. You would implement the actual received payments list here
    return Scaffold(
      appBar: AppBar(
        title: const Text('Received Payments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Export payments data
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 15,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          // Generate dummy payment data
          final paymentDate = DateTime.now().subtract(
            Duration(days: index * 2),
          );
          final formattedDate =
              '${paymentDate.year}-${paymentDate.month.toString().padLeft(2, '0')}-${paymentDate.day.toString().padLeft(2, '0')}';
          final amount = 2500 + (index % 5) * 500;
          final studentName = 'Student ${index % 5 + 1}';
          final className =
              'Class ${['Math', 'Science', 'Physics', 'Chemistry', 'Biology'][index % 5]}';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Icon(Icons.check_circle, color: Colors.green.shade800),
              ),
              title: Text(studentName),
              subtitle: Text(
                '$className\nDate: $formattedDate\nAmount: LKR $amount',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.receipt),
                onPressed: () {
                  // Show receipt
                },
              ),
              onTap: () {
                // Show payment details
              },
            ),
          );
        },
      ),
    );
  }
}
