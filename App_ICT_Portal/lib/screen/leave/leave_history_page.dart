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
    final response = await http.get(Uri.parse(
        'http://192.168.137.1/ICT/API_ICT_Portal/fetch_leave.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
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
            List<LeaveHistory> leaveHistory = snapshot.data!;
            return ListView.builder(
              itemCount: leaveHistory.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2, // Add elevation for a shadow effect
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ), // Add margin for spacing between cards
                  child: ListTile(
                    title: Text('Category: ${leaveHistory[index].category}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reason: ${leaveHistory[index].reason}'),
                        Text('From: ${leaveHistory[index].fromDate}'),
                        Text('To: ${leaveHistory[index].toDate}'),
                        GestureDetector(
                          onTap: () {
                            _openDocument(leaveHistory[index].documentUrl);
                          },
                          child: Text(
                            'Document: ${leaveHistory[index].documentUrl}',
                            style: TextStyle(
                              color: Colors.blue, // Change text color to blue
                              decoration:
                                  TextDecoration.underline, // Add underline
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: leaveHistory[index].status == 'pending'
                        ? Icon(Icons.warning, color: Colors.grey)
                        : leaveHistory[index].status == 'rejected'
                            ? Icon(Icons.cancel, color: Colors.red)
                            : Icon(Icons.check_circle, color: Colors.green),
                    onTap: () {
                      // Navigate to a page to view the document or any other action
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to open or display the document
  void _openDocument(String? documentUrl) async {
    if (documentUrl != null && await canLaunch(documentUrl)) {
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
