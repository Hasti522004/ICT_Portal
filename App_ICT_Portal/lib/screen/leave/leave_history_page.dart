import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

class LeaveHistoryPage extends StatefulWidget {
  @override
  _LeaveHistoryPageState createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  late Future<List<LeaveHistory>> _leaveHistoryFuture;

  @override
  void initState() {
    super.initState();
    _leaveHistoryFuture = fetchLeaveHistory();
  }

  Future<List<LeaveHistory>> fetchLeaveHistory() async {
    final response = await http.get(
        Uri.parse('http://192.168.137.1//ICT/API_ICT_Portal/fetch_leave.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => LeaveHistory.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch leave history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave History'),
        backgroundColor: Color(0xFF00A6BE),
      ),
      body: FutureBuilder<List<LeaveHistory>>(
        future: _leaveHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<LeaveHistory> leaveHistory = snapshot.data!;
            return ListView.builder(
              itemCount: leaveHistory.length,
              itemBuilder: (context, index) => LeaveHistoryListItem(
                leaveHistory: leaveHistory[index],
              ),
            );
          }
        },
      ),
    );
  }
}

class LeaveHistoryListItem extends StatelessWidget {
  final LeaveHistory leaveHistory;

  const LeaveHistoryListItem({required this.leaveHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Category: ${leaveHistory.category}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reason: ${leaveHistory.reason}'),
            Text('From: ${leaveHistory.fromDate}'),
            Text('To: ${leaveHistory.toDate}'),
            GestureDetector(
              onTap: () => _openDocument(context, leaveHistory.documentUrl),
              child: Text(
                'Document: ${leaveHistory.documentUrl}',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          leaveHistory.status == 'pending'
              ? Icons.warning
              : leaveHistory.status == 'rejected'
                  ? Icons.cancel
                  : Icons.check_circle,
          color: leaveHistory.status == 'rejected'
              ? Colors.red
              : leaveHistory.status == 'pending'
                  ? Colors.grey
                  : Colors.green,
        ),
      ),
    );
  }

  void _openDocument(BuildContext context, String documentUrl) async {
    if (await canLaunch(documentUrl)) {
      await launch(documentUrl);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to open the document.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class LeaveHistory {
  final String category;
  final String reason;
  final String fromDate;
  final String toDate;
  final String status;
  final String documentUrl;

  LeaveHistory({
    required this.category,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.documentUrl,
  });

  factory LeaveHistory.fromJson(Map<String, dynamic> json) {
    return LeaveHistory(
      category: json['category'] ?? '', // Assign default value if null
      reason: json['reason'] ?? '', // Assign default value if null
      fromDate: json['from_date'] ?? '', // Assign default value if null
      toDate: json['to_date'] ?? '', // Assign default value if null
      status: json['status'] ?? '', // Assign default value if null
      documentUrl: json['file_url'] ?? '', // Assign default value if null
    );
  }
}
