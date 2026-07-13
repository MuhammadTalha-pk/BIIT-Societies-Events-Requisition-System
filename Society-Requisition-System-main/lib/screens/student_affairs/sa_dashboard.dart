import 'package:flutter/material.dart';
import 'package:society_requisition_system/config.dart';
import 'package:society_requisition_system/models/user.dart';
import 'package:society_requisition_system/screens/common/hamburger_menu.dart';
import '/widgets/custom_navbar.dart';

class SaDashboardScreen extends StatelessWidget {
  final User user;
  final VoidCallback onGoToReview; // ✅ added callback

  const SaDashboardScreen({
    Key? key,
    required this.user,
    required this.onGoToReview, // ✅ required callback
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

              CreateEventButton(
                onPressed: () {
                  onGoToReview();
                },
              ),

              const SizedBox(height: 20),

              RecentRequestsCard(
                requests: [
                  {'title': 'TechFest'},
                  {'title': 'Seminar'},
                  {'title': 'Industrial Visit'},
                ],
              ),

              const SizedBox(height: 20),

              SummaryCard(approved: 5, rejected: 3, pending: 2),
            ],
          ),
        ),
      ),
    );
  }
}

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

class CreateEventButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateEventButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEFFAF3),
        foregroundColor: const Color(0xFF093030),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      icon: const Icon(Icons.preview),
      label: const Text('Review Requisitions'),
      onPressed: onPressed,
    );
  }
}

class RecentRequestsCard extends StatelessWidget {
  final List<Map<String, String>> requests;

  const RecentRequestsCard({required this.requests});

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
              'New Requests',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ...requests.map(
              (req) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '- ${req['title']}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  // Text(
                  //   'Status: ${_statusIcon(req['status'])}',
                  //   style: const TextStyle(color: Colors.black),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // String _statusIcon(String? status) {
  //   switch (status) {
  //     case 'approved':
  //       return '✔';
  //     case 'pending':
  //       return '?';
  //     case 'rejected':
  //       return '✖';
  //     default:
  //       return '';
  //   }
  // }
}

class SummaryCard extends StatelessWidget {
  final int approved;
  final int rejected;
  final int pending;

  const SummaryCard({
    required this.approved,
    required this.rejected,
    required this.pending,
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
            Text('Total: ${approved + rejected + pending}'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [Text('Approved'), Text('$approved')]),
                const VerticalDivider(),
                Column(children: [Text('Rejected'), Text('$rejected')]),
                const VerticalDivider(),
                Column(children: [Text('Pending'), Text('$pending')]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
