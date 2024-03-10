import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttributePage extends StatefulWidget {
  final List<Map<String, String>> selectedStudents;

  const AttributePage({Key? key, required this.selectedStudents})
      : super(key: key);

  @override
  _AttributePageState createState() => _AttributePageState();
}

class _AttributePageState extends State<AttributePage> {
  final List<String> _rewards = ['Best', 'Good', 'Average', 'Poor', 'Worst'];
  final List<Map<String, List<String>>> _criteria = [
    {
      'Knowledge Base': [
        'Deep Understanding',
        'Problem-solving',
        'Research Skills'
      ]
    },
    {
      'Problem Analysis': [
        'Analytical Skills',
        'Critical Thinking',
        'Solution Proposals'
      ]
    },
    {
      'Investigation': ['Research Methodology', 'Data Analysis', 'Conclusions']
    },
    {
      'Design': ['Creativity', 'Innovative Solutions', 'Technical Competence']
    },
    {
      'Engineering Tools': [
        'Tool Proficiency',
        'Software Skills',
        'Hardware Skills'
      ]
    },
    {
      'Team Work': ['Collaboration', 'Communication', 'Responsibility']
    },
    {
      'Communication Skills': ['Clarity', 'Presentation', 'Listening Skills']
    },
    {
      'Professionalism': ['Punctuality', 'Ethics', 'Attitude']
    },
    {
      'Society & Environment': [
        'Social Awareness',
        'Environmental Consciousness',
        'Community Engagement'
      ]
    },
    {
      'Economics': [
        'Financial Literacy',
        'Resource Management',
        'Cost-effectiveness'
      ]
    },
    {
      'Ethics and Equity': ['Fairness', 'Equality', 'Integrity']
    },
    {
      'Lifelong Learning': [
        'Curiosity',
        'Adaptability',
        'Continuous Improvement'
      ]
    }
  ];
  Map<String, String?> _feedback = {};

  Future<void> _submitFeedback(String professorId) async {
    // Iterate over selected students and submit feedback for each
    for (var student in widget.selectedStudents) {
      // Construct the feedback data object
      Map<String, dynamic> feedbackData = {
        'enrollment_number': student['enroll'],
        'professor_id': professorId,
        // Add other necessary fields here
        ..._feedback,
      };

      // Make an HTTP POST request to the API endpoint
      final response = await http.post(
        Uri.parse(
            'http://192.168.137.1/ICT/API_ICT_Portal/insert_student_reward.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(feedbackData),
      );

      // Check the response status
      // Check the response status
      if (response.statusCode == 200) {
        print(feedbackData);
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(
                  'Feedback submitted successfully for enrollment number: ${student['enroll']}'),
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
      } else {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Error submitting feedback for enrollment number ${student['enroll']}: ${response.body}'),
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
  }

  @override
  Widget build(BuildContext context) {
    String names =
        widget.selectedStudents.map((student) => student['name']!).join(", ");
    return Scaffold(
      appBar: AppBar(title: Text('Provide Feedback')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Student Names: $names'),
              SizedBox(height: 16),
              for (var attribute in _criteria)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attribute.keys.first,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Column(
                      children: attribute.values.first.map<Widget>((subPoint) {
                        return ListTile(
                          title: Text(
                            subPoint,
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: DropdownButton<String>(
                            hint: Text('Select Reward'),
                            value: _feedback[subPoint],
                            onChanged: (newValue) {
                              setState(() {
                                _feedback[subPoint] = newValue!;
                              });
                            },
                            items: _rewards.map<DropdownMenuItem<String>>(
                              (value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _submitFeedback('user_id'),
                child: const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
