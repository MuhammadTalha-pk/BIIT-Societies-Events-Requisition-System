import 'package:flutter/material.dart';
import '/widgets/custom_navbar.dart';
import 'staff_dashboard.dart';
import 'pending.dart';
import 'completed.dart';
import '/models/user.dart';

class StaffHomeScreen extends StatefulWidget {
  final User user;

  const StaffHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StaffHomeScreenState createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  int _selectedIndex = 0;

  void goToPendingScreen() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _onNavStaffemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      StaffDashboardScreen(user: widget.user, onGoToPending: goToPendingScreen),
      PendingScreen(),
      CompletedScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        role: "staffHead",
        currentIndex: _selectedIndex,
        onTap: _onNavStaffemTapped,
      ),
    );
  }
}
