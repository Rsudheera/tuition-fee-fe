import 'package:flutter/material.dart';
import '../../../core/utils/notification_utils.dart';
import '../../../data/models/teacher.dart';
import '../../widgets/profile/education_qualification_widget.dart';

class ProfileScreen extends StatefulWidget {
  final Teacher? teacher;

  const ProfileScreen({super.key, this.teacher});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Teacher _teacher;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<String> _qualifications = [];

  @override
  void initState() {
    super.initState();
    // Initialize with mock data if no teacher provided
    _teacher =
        widget.teacher ??
        Teacher(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          phone: '+1234567890',
          profileImage: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

    _firstNameController.text = _teacher.firstName;
    _lastNameController.text = _teacher.lastName;
    _emailController.text = _teacher.email;
    _phoneController.text = _teacher.phone;

    // Initialize with teacher qualifications or defaults
    _qualifications = _teacher.educationalQualifications.isNotEmpty
        ? List.from(_teacher.educationalQualifications)
        : [
            'BSc in Computer Science',
            'Masters in Education',
            'Advanced Certification in Mathematics',
          ];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers to original values if canceling edit
        _firstNameController.text = _teacher.firstName;
        _lastNameController.text = _teacher.lastName;
        _emailController.text = _teacher.email;
        _phoneController.text = _teacher.phone;
      }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would save this to your backend
      setState(() {
        _teacher = _teacher.copyWith(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          educationalQualifications: _qualifications,
          updatedAt: DateTime.now(),
        );
        _isEditing = false;
      });

      NotificationUtils.showSuccessNotification(
        context,
        'Profile updated successfully',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're in a tab (no app bar needed) or standalone
    final bool isInTab = ModalRoute.of(context)?.settings.name != '/profile';

    if (isInTab) {
      // Inside the tab, don't need the app bar
      return buildContent();
    } else {
      // Standalone profile page with app bar
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          actions: [
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: _toggleEditMode,
            ),
            if (_isEditing)
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _saveProfile,
              ),
          ],
        ),
        body: buildContent(),
      );
    }
  }

  Widget buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildProfileDetails(),
              if (_isEditing) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: _teacher.profileImage != null
                  ? NetworkImage(_teacher.profileImage!)
                  : null,
              child: _teacher.profileImage == null
                  ? Icon(Icons.person, size: 60, color: Colors.grey.shade700)
                  : null,
            ),
            if (_isEditing)
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    // Add image picker functionality
                  },
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (!_isEditing)
          Text(
            _teacher.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  Widget _buildProfileDetails() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditing) ...[
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              readOnly: !_isEditing,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              readOnly: !_isEditing,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            EducationQualificationWidget(
              isEditing: _isEditing,
              qualifications: _qualifications,
              onQualificationsChanged: (updatedQualifications) {
                setState(() {
                  _qualifications = updatedQualifications;
                });
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _buildInfoRow('Member Since', _formatDate(_teacher.createdAt)),
            const SizedBox(height: 8),
            _buildInfoRow('Last Updated', _formatDate(_teacher.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.shade100 : null,
      ),
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
