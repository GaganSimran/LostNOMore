import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';
import '../Models/report_service.dart';
import '../Models/report_model.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Future<List<ReportModel>> futureReports;

  @override
  void initState() {
    super.initState();
    futureReports = ReportService.fetchReports();
  }

  void _handleNavigation(BuildContext context, String item) {
    switch (item) {
      case 'Dashboard':
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 'Manage Posts':
        Navigator.pushNamed(context, '/panel');
        break;
      case 'Reports':
        break;
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  Widget _buildRow(String userName, int reportCount) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFC4C4C4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(userName),
          ),
          Expanded(
            child: Text(
              reportCount.toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _groupReportsByUser(List<ReportModel> reports) {
    final Map<String, int> groupedReports = {};

    for (final report in reports) {
      final String name = report.name.trim().isEmpty ? 'Unknown User' : report.name.trim();

      if (groupedReports.containsKey(name)) {
        groupedReports[name] = groupedReports[name]! + 1;
      } else {
        groupedReports[name] = 1;
      }
    }

    return groupedReports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Row(
        children: [
          AppSidebar(
            selected: 'Reports',
            onItemTap: (item) => _handleNavigation(context, item),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(title: 'Reports'),
                  const SizedBox(height: 30),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reports',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCCCCC),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'User',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '# Reports',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          Expanded(
                            child: FutureBuilder<List<ReportModel>>(
                              future: futureReports,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }

                                final reports = snapshot.data ?? [];

                                if (reports.isEmpty) {
                                  return const Center(
                                    child: Text('No reports found'),
                                  );
                                }

                                final groupedReports = _groupReportsByUser(reports);
                                final users = groupedReports.entries.toList();

                                return ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    final user = users[index];
                                    return _buildRow(user.key, user.value);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}