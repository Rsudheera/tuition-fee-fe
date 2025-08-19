import 'package:flutter/material.dart';
import '../../../data/models/tuition_class.dart';

class ClassCard extends StatelessWidget {
  final TuitionClass tuitionClass;
  final VoidCallback? onTap;

  const ClassCard({super.key, required this.tuitionClass, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80, // Reduced height
              decoration: BoxDecoration(
                color: _getSubjectColor(tuitionClass.subject),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  tuitionClass.subject,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Slightly smaller font
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Use minimal space needed
                  children: [
                    Text(
                      tuitionClass.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15, // Slightly smaller font
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3), // Reduced spacing
                    Text(
                      tuitionClass.schedule,
                      style: const TextStyle(fontSize: 13), // Smaller font
                      maxLines: 1, // Only show one line
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(), // Push the row to the bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LKR ${tuitionClass.monthlyFee.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 13, // Smaller font
                          ),
                        ),
                        Text(
                          '${tuitionClass.currentStudents}/${tuitionClass.maxStudents}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: tuitionClass.hasAvailableSlots
                                ? Colors.blue
                                : Colors.red,
                            fontSize: 13, // Smaller font
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ), // Reduced padding
              decoration: BoxDecoration(
                color: tuitionClass.isActive ? Colors.green : Colors.grey,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                tuitionClass.isActive ? 'Active' : 'Inactive',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13, // Smaller font
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    // Generate a consistent color based on the subject
    final List<Color> colors = [
      Colors.blue.shade700,
      Colors.purple.shade700,
      Colors.red.shade700,
      Colors.teal.shade700,
      Colors.orange.shade700,
      Colors.indigo.shade700,
      Colors.pink.shade700,
      Colors.deepOrange.shade700,
    ];

    // Use subject's hash code to pick a color from the list
    final int index = subject.hashCode.abs() % colors.length;
    return colors[index];
  }
}
