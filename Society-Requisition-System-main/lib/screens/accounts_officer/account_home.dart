import 'package:flutter/material.dart';
import 'package:society_requisition_system/models/user.dart';
import '/widgets/custom_navbar.dart';
import 'account_dashboard.dart';
import 'review.dart';
import 'accepted.dart';
import 'rejected.dart';
// Import other necessary screens

class AccountHomeScreen extends StatefulWidget {
  final User user;

  const AccountHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AccountHomeScreenState createState() => _AccountHomeScreenState();
}

class _AccountHomeScreenState extends State<AccountHomeScreen> {
  int _selectedIndex = 0;

  void goToReviewScreen() {
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
    final List<Widget> screens = [
      AccountDashboardScreen(user: widget.user, onGoToReview: goToReviewScreen),
      ReviewScreen(),
      AcceptedScreen(),
      RejectedScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Displays the selected screen
        children: screens, // List of screens to show based on selection
      ),
      bottomNavigationBar: CustomBottomNavBar(
        role: "studentAffairs", // Pass role dynamically to navbar
        currentIndex: _selectedIndex, // Provide the current index
        onTap: _onNavItemTapped, // Handle navigation item tap
      ),
    );
  }
}
