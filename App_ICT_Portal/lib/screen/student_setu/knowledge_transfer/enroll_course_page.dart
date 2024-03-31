import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({Key? key}) : super(key: key);

  @override
  _CourseListPageState createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage>
    with SingleTickerProviderStateMixin {
  late List<dynamic> _courseList;
  bool _isLoading = true;
  Map<String, String> studentMap =
      {}; // Map to store student data (enrollment number -> name)

  @override
  void initState() {
    super.initState();
    _fetchCourse();
    fetchStudentDataAndBuildConversations();
  }

  Future<void> fetchStudentDataAndBuildConversations() async {
    try {
      // Fetch student data
      final studentResponse = await http.get(Uri.parse(
          'https://www.ictmu.in/ict_portal/api/student.php?key=student@ict'));
      if (studentResponse.statusCode == 200) {
        final List<dynamic> students = json.decode(studentResponse.body);
        // Populate student map
        studentMap = Map.fromIterable(students,
            key: (student) => student['enroll'],
            value: (student) =>
                '${student['fn']} ${student['mn']} ${student['ln']}');
      } else {
        throw Exception('Failed to fetch student data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    print(studentMap);
  }

  // Fetch student name from the student map
  String getStudentName(String genId) {
    return studentMap[genId] ?? genId;
  }

  Future<void> _fetchCourse() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://www.ictmu.in/ict_portal/api/setu-course.php?key=setu-course@ict'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filter queries where rec_id is equal to 0
        _courseList = data.where((course) => course['rec_id'] == '').toList();

        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch Course');
      }
    } catch (e) {
      print('Error fetching Course: $e');
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch Course. Please try again later.'),
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
      appBar: CustomAppBar(title: "Enroll Course"),
      drawer: SideMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _courseList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No course discussions found.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _courseList.length,
                  itemBuilder: (context, index) {
                    final course = _courseList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getStudentName(
                                  course['creater'])), // Display gen_id
                              SizedBox(height: 8),
                              Text(course['course'] ?? ''),
                              SizedBox(height: 8),
                              Text('Subject: ${course['subject'] ?? ''}'),
                              Text('Description: ${course['des'] ?? ''}'),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Implement accept functionality here
                              // You can call a function to accept the course or navigate to another screen
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                            ),
                            child: Text('Accept'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
