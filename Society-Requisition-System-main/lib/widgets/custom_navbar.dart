import 'package:flutter/material.dart'; // Add more screens as needed

class CustomBottomNavBar extends StatelessWidget {
  final String role; // The role passed dynamically
  final int currentIndex; // The current selected index
  final ValueChanged<int> onTap; // Callback to handle item tap

  const CustomBottomNavBar({
    required this.role,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items;

    // Dynamically create navigation items based on the role
    if (role == 'chairperson') {
      items = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.pending),
          label: 'Status',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'All'),
      ];
    } else if (role == 'studentAffairs' || role == 'accountsOfficer') {
      items = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.preview),
          label: 'Review',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.event_available),
          label: 'Approved',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.event_busy),
          label: 'Rejected',
        ),
      ];
    } else {
      // IT Head and Staff Head
      items = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Pending',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.fact_check),
          label: 'Completed',
        ),
      ];
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: items,
      currentIndex: currentIndex, // Highlight the selected index
      onTap: (index) {
        // Call the provided onTap to update the selected index
        onTap(index);
      },
    );
  }
}
