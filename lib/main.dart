import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'data/services/auth_service.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize auth service
  final authService = AuthService();
  final isAuthenticated = await authService.initializeAuth();

  runApp(TuitionFeeApp(isAuthenticated: isAuthenticated));
}

class TuitionFeeApp extends StatelessWidget {
  final bool isAuthenticated;

  const TuitionFeeApp({super.key, this.isAuthenticated = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuition Fee Manager',
      theme: AppTheme.lightTheme,
      initialRoute: isAuthenticated ? '/dashboard' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
