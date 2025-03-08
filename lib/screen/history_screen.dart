import 'package:flutter/material.dart';
import 'package:qr_scanner/database/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> scanHistory;

  const HistoryScreen({super.key, required this.scanHistory});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<Map<String, dynamic>> scanHistory;

  @override
  void initState() {
    super.initState();
    scanHistory = widget.scanHistory; // Lấy scanHistory từ widget
  }

  Future<void> _loadScanHistory() async {
    final allRows = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      scanHistory = allRows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: scanHistory.isEmpty
          ? Center(
              child: Text("No data.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith()))
          : ListView.builder(
              itemCount: scanHistory.length,
              itemBuilder: (context, index) {
                var item = scanHistory[index];
                return ListTile(
                  title: Text(item[DatabaseHelper.columnScanData]),
                  subtitle: Text(
                    DateTime.fromMillisecondsSinceEpoch(
                            item[DatabaseHelper.columnTimestamp])
                        .toString(),
                  ),
                );
              },
            ),
    );
  }
}
