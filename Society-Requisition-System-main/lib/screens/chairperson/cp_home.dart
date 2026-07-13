import 'package:flutter/material.dart';
import 'package:society_requisition_system/models/user.dart';
import '/widgets/custom_navbar.dart';
import 'cp_dashboard.dart';
import 'all.dart';
import 'add.dart';
import 'status.dart';
// Import other necessary screens

class ChairpersonHomeScreen extends StatefulWidget {
  final User user;

  const ChairpersonHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChairpersonHomeScreenState createState() => _ChairpersonHomeScreenState();
}

class _ChairpersonHomeScreenState extends State<ChairpersonHomeScreen> {
  int _selectedIndex = 0;

  void goToAddScreen() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  // Handle the index change when a bottom nav item is tapped
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      ChairpersonDashboardScreen(user: widget.user, onGoToAdd: goToAddScreen),
      AddScreen(),
      StatusScreen(),
      AllScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Displays the selected screen
        children: _screens, // List of screens to show based on selection
      ),
      bottomNavigationBar: CustomBottomNavBar(
        role: "chairperson", // Pass role dynamically to navbar
        currentIndex: _selectedIndex, // Provide the current index
        onTap: _onNavItemTapped, // Handle navigation item tap
      ),
    );
  }
}
