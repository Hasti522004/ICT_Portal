import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';

class AnonymousFeedbackPage extends StatefulWidget {
  static const String fid = 'your_fid_here'; // Static value for fid

  const AnonymousFeedbackPage({Key? key}) : super(key: key);

  @override
  _AnonymousFeedbackPageState createState() => _AnonymousFeedbackPageState();
}

class _AnonymousFeedbackPageState extends State<AnonymousFeedbackPage> {
  late List<dynamic> _feedbackList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFeedback();
  }

  Future<void> _fetchFeedback() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://www.ictmu.in/ict_portal/api/anonymous-feeedback.php?key=anonymous-feeedback@ict'));

      if (response.statusCode == 200) {
        setState(() {
          _feedbackList = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch feedback');
      }
    } catch (e) {
      print('Error fetching feedback: $e');
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch feedback. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Anonymous Feedback"),
      drawer: SideMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _feedbackList.isEmpty
              ? Center(child: Text('No feedback available'))
              : ListView.builder(
                  itemCount: _feedbackList.length,
                  itemBuilder: (context, index) {
                    final feedback = _feedbackList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          title: Text(feedback['feedback'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('Semester: ${feedback['sem'] ?? ''}'),
                              Text('Date: ${feedback['date'] ?? ''}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
