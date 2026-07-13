import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class AllScreen extends StatefulWidget {
  const AllScreen({Key? key}) : super(key: key);

  @override
  State<AllScreen> createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allTasks = [
    {'name': 'Task 1', 'status': 'Accepted', 'date': '20/05/25'},
    {'name': 'Task 4', 'status': 'Rejected', 'date': '22/05/25'},
    {'name': 'Task 10', 'status': 'Pending', 'date': '22/05/25'},
    {'name': 'Task 15', 'status': 'Accepted', 'date': '22/05/25'},
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

  Widget getStatusWidget(String status) {
    Color bgColor;
    switch (status.toLowerCase()) {
      case 'accepted':
        bgColor = Colors.green;
        break;
      case 'rejected':
        bgColor = Colors.red;
        break;
      case 'pending':
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bgColor),
      ),
      child: Text(
        status,
        style: TextStyle(color: bgColor, fontWeight: FontWeight.bold),
      ),
    );
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
                    'All Tasks',
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

            // Search Field
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
                    flex: 2,
                    child: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
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
                        Expanded(flex: 2, child: Text(task['name']!)),
                        Expanded(
                          flex: 2,
                          child: getStatusWidget(task['status']!),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            task['date']!,
                            textAlign: TextAlign.right,
                          ),
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
