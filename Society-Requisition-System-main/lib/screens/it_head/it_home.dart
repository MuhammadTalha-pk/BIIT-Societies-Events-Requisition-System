import 'package:flutter/material.dart';
import '/widgets/custom_navbar.dart';
import 'it_dashboard.dart';
import 'pending.dart';
import 'completed.dart';
import '/models/user.dart';

class ItHomeScreen extends StatefulWidget {
  final User user;

  const ItHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ItHomeScreenState createState() => _ItHomeScreenState();
}

class _ItHomeScreenState extends State<ItHomeScreen> {
  int _selectedIndex = 0;

  void goToPendingScreen() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      ItDashboardScreen(user: widget.user, onGoToPending: goToPendingScreen),
      PendingScreen(),
      CompletedScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        role: "itHead",
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
