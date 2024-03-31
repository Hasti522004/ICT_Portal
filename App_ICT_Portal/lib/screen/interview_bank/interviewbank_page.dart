import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/interview_bank/interviewForm_page.dart';
import 'package:ict_portal/screen/interview_bank/interview_bank_student_model/Student.dart';
import 'package:ict_portal/screen/interview_bank/studentDetail_page.dart';

class InterviewBankPage extends StatefulWidget {
  const InterviewBankPage({Key? key});

  @override
  _InterviewBankPageState createState() => _InterviewBankPageState();
}

class _InterviewBankPageState extends State<InterviewBankPage>
    with SingleTickerProviderStateMixin {
  Map<int, bool?> showDetailsMap = {};
  Map<int, bool?> showInterviewButtonMap = {};
  List<Student> students = [];
  TextEditingController searchController = TextEditingController();
  List<Student> filteredStudents = [];
  Map<String, String> enrollmentToNameMap =
      {}; // Map to store enrollment numbers and student names
  Map<String, String> studentMap =
      {}; // Map to store student data (enrollment number -> name)

  @override
  void initState() {
    super.initState();
    fetchStudents();
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
  String getStudentName(String enrollmentNumber) {
    return studentMap[enrollmentNumber] ?? 'Unknown';
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.ictmu.in/ict_portal/api/interview-bank.php?key=interview-bank@ict'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          students =
              data.map((studentData) => Student.fromJson(studentData)).toList();
          filteredStudents = List.from(students);

          // Populate the map with enrollment numbers and student names
          students.forEach((student) {
            enrollmentToNameMap[student.enr] =
                '${student.fn} ${student.mn} ${student.ln}';
          });
        });
      } else {
        throw Exception('Failed to fetch student data');
      }
    } catch (e) {
      print('Error fetching student data: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Failed to fetch student data. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void filterStudents(String query) {
    setState(() {
      filteredStudents = students.where((student) {
        // Check if the query matches the student's name
        bool matchesName = getStudentName(student.enr)
            .toLowerCase()
            .contains(query.toLowerCase());

        // Check if the query matches the company name
        bool matchesCompanyName =
            student.title.toLowerCase().contains(query.toLowerCase());

        // Return true if the query matches either the student name or the company name
        return matchesName || matchesCompanyName;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Interview Bank',
      ),
      drawer: SideMenu(),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: filterStudents,
                  decoration: const InputDecoration(
                    labelText: 'Search by Student Name or Company Name',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(filteredStudents[index].title ??
                                    'Unknown'), // Display company name
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      showDetailsMap[index] =
                                          !(showDetailsMap[index] ?? false);
                                      showInterviewButtonMap[index] =
                                          !(showInterviewButtonMap[index] ??
                                              false);
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (showDetailsMap[index] == true)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getStudentName(
                                          filteredStudents[index].enr) ??
                                      'Unknown'),

                                  Text('Date: ${filteredStudents[index].date}'),
                                  // Add more fields as needed
                                ],
                              ),
                            if (showInterviewButtonMap[index] == true)
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the student details page or perform desired action
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDetailsPage(
                                        studentName: getStudentName(
                                                filteredStudents[index].enr) ??
                                            'Unknown',
                                        student: filteredStudents[index],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Interview'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InterviewForm(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
