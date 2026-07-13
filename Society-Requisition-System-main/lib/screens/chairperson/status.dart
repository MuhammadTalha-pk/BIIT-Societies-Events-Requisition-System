import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> tasks = const [
    {'name': 'Event No.1', 'status': 'Pending'},
    {'name': 'Event No.2', 'status': 'In-Process'},
    {'name': 'Event No.3', 'status': 'Completed'},
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In-Process':
        return Colors.orange;
      case 'Pending':
      default:
        return Colors.grey;
    }
  }

  List<Color> _getDotColors(String status) {
    switch (status) {
      case 'Completed':
        return [Colors.green, Colors.green, Colors.green];
      case 'In-Process':
        return [Colors.orange, Colors.orange, Colors.grey];
      case 'Pending':
      default:
        return [Colors.grey, Colors.grey, Colors.grey];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFEF5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF00D09E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Text(
                'Status Tracker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Events
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final status = task['status']!;
                  final dotColors = _getDotColors(status);
                  final statusColor = _getStatusColor(status);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF5EA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Step indicators
                        Row(
                          children: List.generate(3, (i) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dotColors[i],
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 12),

                        // Status Badge
                        Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
