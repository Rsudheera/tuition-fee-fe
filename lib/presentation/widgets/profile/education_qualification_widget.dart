import 'package:flutter/material.dart';

class EducationQualificationWidget extends StatefulWidget {
  final bool isEditing;
  final List<String> qualifications;
  final Function(List<String>) onQualificationsChanged;

  const EducationQualificationWidget({
    Key? key,
    required this.isEditing,
    required this.qualifications,
    required this.onQualificationsChanged,
  }) : super(key: key);

  @override
  State<EducationQualificationWidget> createState() =>
      _EducationQualificationWidgetState();
}

class _EducationQualificationWidgetState
    extends State<EducationQualificationWidget> {
  late List<String> _qualifications;
  final TextEditingController _newQualificationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _qualifications = List.from(widget.qualifications);
  }

  void _addQualification() {
    if (_newQualificationController.text.isNotEmpty) {
      setState(() {
        _qualifications.add(_newQualificationController.text);
        _newQualificationController.clear();
      });
      widget.onQualificationsChanged(_qualifications);
    }
  }

  void _removeQualification(int index) {
    setState(() {
      _qualifications.removeAt(index);
    });
    widget.onQualificationsChanged(_qualifications);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Educational Qualifications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (widget.isEditing) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newQualificationController,
                  decoration: InputDecoration(
                    hintText: 'Add qualification (e.g., BSc Computer Science)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle),
                color: Theme.of(context).primaryColor,
                onPressed: _addQualification,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (_qualifications.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'No educational qualifications added yet.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _qualifications.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(_qualifications[index]),
                  trailing: widget.isEditing
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeQualification(index),
                        )
                      : null,
                ),
              );
            },
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _newQualificationController.dispose();
    super.dispose();
  }
}
