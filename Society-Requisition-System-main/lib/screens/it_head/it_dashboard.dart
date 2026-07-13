import 'package:flutter/material.dart';
import '../common/hamburger_menu.dart';
import '/models/user.dart';

class ItDashboardScreen extends StatelessWidget {
  final User user;
  final VoidCallback onGoToPending; // ✅ added callback

  const ItDashboardScreen({
    Key? key,
    required this.user,
    required this.onGoToPending, // ✅ required callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu(user: user),
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xFFF1FFF3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hi, ${user.name.split(' ').first}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('Good Day', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              // ✅ Hook up the button to call the callback
              PendingTaskButton(onPressed: onGoToPending),

              const SizedBox(height: 20),

              TodayTasksCard(
                tasks: [
                  {'title': 'TechFest'},
                  {'title': 'LINQ Seminar'},
                  {'title': 'Industrial Visit'},
                ],
              ),

              const SizedBox(height: 20),

              SummaryCard(total: 32, today: 1, tommorrow: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (Rest of the file remains the same)

// TODO: Build these widgets below one by one
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF00D09E),
      elevation: 0,
      title: const Text(''),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {
            // TODO: handle notifications
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class PendingTaskButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PendingTaskButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEFFAF3),
        foregroundColor: const Color(0xFF093030),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      icon: const Icon(Icons.receipt),
      label: const Text('See Pending Tasks'),
      onPressed: onPressed,
    );
  }
}

class TodayTasksCard extends StatelessWidget {
  final List<Map<String, String>> tasks;

  const TodayTasksCard({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF00D09E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ...tasks.map(
              (req) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '- ${req['title']}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final int total;
  final int today;
  final int tommorrow;

  const SummaryCard({
    required this.total,
    required this.today,
    required this.tommorrow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text('Total: $total'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [Text('Today'), Text('$today')]),
                const VerticalDivider(),
                Column(children: [Text('Tomorrow'), Text('$tommorrow')]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
