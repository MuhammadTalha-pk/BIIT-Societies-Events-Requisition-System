import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userRole = prefs.getString('userRole') ?? '';

    // debugPrint('Splash Screen(1)');

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, _getHomeRoute(userRole));
      // debugPrint('Login before true(2)');
      debugPrint(_getHomeRoute(userRole));
    } else {
      Navigator.pushReplacementNamed(context, '/login');
      // debugPrint('Login before false(3)');
    }
  }

  String _getHomeRoute(String role) {
    switch (role) {
      case 'Chairperson':
        return '/cp_home';
      case 'StudentAffairs':
        return '/sa_home';
      case 'AccountOfficer':
        return '/account_home';
      case 'StaffHead':
        return '/staff_home';
      case 'ITHead':
        return '/it_home';
      default:
        return '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00D09E), // You can customize background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // University Logo
            Image.asset('assets/biit_logo.png', width: 150, height: 150),
            SizedBox(height: 20),
            // App Name Text
            Text(
              'BIIT Societies Requisitions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            // Loading Animation
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
