import 'package:flutter/material.dart';
import '../../../core/utils/notification_utils.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFormValid = false;

  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_validateRequiredFields);
    _emailController.addListener(_validateRequiredFields);
    _passwordController.addListener(_validateRequiredFields);
    _confirmPasswordController.addListener(_validateRequiredFields);
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_validateRequiredFields);
    _emailController.removeListener(_validateRequiredFields);
    _passwordController.removeListener(_validateRequiredFields);
    _confirmPasswordController.removeListener(_validateRequiredFields);
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateRequiredFields() {
    final fullNameValid = _fullNameController.text.isNotEmpty;
    final emailValid =
        _emailController.text.isNotEmpty &&
        RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(_emailController.text);
    final passwordValid =
        _passwordController.text.isNotEmpty &&
        _passwordController.text.length >= 6;
    final confirmPasswordValid =
        _confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text == _passwordController.text;

    setState(() {
      _isFormValid =
          fullNameValid && emailValid && passwordValid && confirmPasswordValid;
    });
  }

  Future<void> _handleRegister() async {
    // Check if the required fields are valid
    if (!_isFormValid || !_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authRepository.register(
        name: _fullNameController.text,
        businessName: _businessNameController.text.isEmpty
            ? _fullNameController.text
            : _businessNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text.isEmpty ? "" : _phoneController.text,
      );

      if (mounted) {
        NotificationUtils.showSuccessNotification(
          context,
          'Registration successful! Please login.',
        );
        // Navigate back to login
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        NotificationUtils.showErrorNotification(
          context,
          'Registration failed: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.school, size: 64, color: Colors.indigo),
                      const SizedBox(height: 16),
                      const Text(
                        'Tuition Fee Manager',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create a new account',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name *',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _businessNameController,
                        decoration: const InputDecoration(
                          labelText: 'Business Name',
                          prefixIcon: Icon(Icons.business),
                        ),
                        // Business name is optional
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          prefixIcon: Icon(Icons.email),
                        ),
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
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password *',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          // Phone is optional, but if provided, validate it
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_isLoading || !_isFormValid)
                              ? null
                              : _handleRegister,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white70,
                                  ),
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '* Required fields',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Already have an account? Sign In'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
