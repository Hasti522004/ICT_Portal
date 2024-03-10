import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/screen/student_reward/student_reward_attribute_page.dart';

class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({Key? key}) : super(key: key);

  @override
  State<StudentInfoPage> createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  List<dynamic> students = [];
  List<dynamic> filteredStudents = [];
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> selectedStudents = [];

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://www.ictmu.in/ict_portal/api/student.php?key=student@ict'),
    );

    if (response.statusCode == 200) {
      setState(() {
        students = json.decode(response.body);
        filteredStudents = students;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredStudents = students;
      });
      return;
    }

    List<dynamic> dummyListData = students.where((item) {
      String fullName = "${item['fn']} ${item['mn']} ${item['ln']}".trim();
      return fullName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredStudents = dummyListData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Student Data'),
          actions: [
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttributePage(
                      selectedStudents: selectedStudents,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: filterSearchResults,
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search by name",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  var student = filteredStudents[index];
                  bool isSelected = selectedStudents.any((selectedStudent) =>
                      selectedStudent['enroll'] == student['enroll']);

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    color: isSelected ? Colors.lightGreenAccent : Colors.white,
                    child: ListTile(
                      title: Text(
                        '${student['fn']} ${student['mn']} ${student['ln']}'
                            .trim(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Enroll No: ${student['enroll']}'),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          var studentInfo = {
                            'name':
                                '${student['fn']} ${student['mn']} ${student['ln']}'
                                    .trim(),
                            'enroll': student['enroll']
                                .toString(), // Ensure enrollment number is converted to string
                          } as Map<String,
                              String>; // Explicitly cast to Map<String, String>

                          var index = selectedStudents.indexWhere((element) =>
                              element['enroll'] == student['enroll']);
                          if (index != -1) {
                            selectedStudents.removeAt(index);
                          } else {
                            selectedStudents.add(studentInfo);
                          }
                        });
                      },
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
