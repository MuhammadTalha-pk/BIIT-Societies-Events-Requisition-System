import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allTasks = [
    {'name': 'Programming Society', 'date': '20/05/25'},
    {'name': 'Task 4', 'date': '22/05/25'},
    {'name': 'Task 10', 'date': '22/05/25'},
    {'name': 'Task 15', 'date': '22/05/25'},
  ];

  List<Map<String, String>> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _filteredTasks = List.from(_allTasks);
    _searchController.addListener(_filterTasks);
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = _allTasks.where((task) {
        return task['name']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFEF5),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF00D09E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 8),
                  Text(
                    'Completed Tasks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search Field using your custom widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                hintText: "Search",
                icon: Icons.search,
                controller: _searchController,
              ),
            ),

            const SizedBox(height: 20),

            // Table Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  return Container(
                    color: index % 2 == 0
                        ? const Color(0xFFDFF5EA)
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(task['name']!)),
                        Text(task['date']!),
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
