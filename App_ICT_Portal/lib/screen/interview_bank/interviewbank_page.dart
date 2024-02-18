import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/interview_bank/Student.dart';
import 'package:ict_portal/screen/interview_bank/interviewForm_page.dart';
import 'package:ict_portal/screen/interview_bank/studentDetail_page.dart';

class InterviewBankPage extends StatefulWidget {
  const InterviewBankPage({super.key});

  @override
  _InterviewBankPageState createState() => _InterviewBankPageState();
}

class _InterviewBankPageState extends State<InterviewBankPage> {
  Map<int, bool?> showDetailsMap = {};
  Map<int, bool?> showInterviewButtonMap = {};
  List<Student> students = [];
  TextEditingController searchController = TextEditingController();
  List<Student> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.137.1/dashboard/API_ICT_promotion/fetch_interviewbank.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          students =
              data.map((studentData) => Student.fromJson(studentData)).toList();
          filteredStudents = List.from(students);
        });
      } else {
        throw Exception('Failed to fetch student data');
      }
    } catch (e) {
      print('Error fetching student data: $e');
      // ignore: use_build_context_synchronously
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
        return student.studentName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            student.companyName.toLowerCase().contains(query.toLowerCase());
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
                    labelText: 'Search by Student or Company Name',
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
                                Text(filteredStudents[index].studentName),
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
                                  Text(
                                      'Enrollment: ${filteredStudents[index].enrollment}'),
                                  Text(
                                      'Company Name: ${filteredStudents[index].companyName}'),
                                  Text(
                                      'Package: ${filteredStudents[index].package}'),
                                  Text('Date: ${filteredStudents[index].date}'),
                                ],
                              ),
                            if (showInterviewButtonMap[index] == true)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDetailsPage(
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
