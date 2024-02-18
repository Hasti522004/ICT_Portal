import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/Course.dart';


class EnrollCoursePage extends StatefulWidget {
  @override
  _EnrollCoursePageState createState() => _EnrollCoursePageState();
}

class _EnrollCoursePageState extends State<EnrollCoursePage> {
  List<Course> enrolledCourses = []; // List to store enrolled courses

  // Fetch course data from the API
  Future<void> fetchCourses() async {
    final response = await http.get(Uri.parse(
        'http://192.168.137.1/ICT/API_ICT_Portal/fetch_course.php'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final List<dynamic> coursesData = jsonDecode(response.body);
      setState(() {
        enrolledCourses =
            coursesData.map((data) => Course.fromJson(data)).toList();
      });
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load courses');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch courses when the widget initializes
    fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Enrolled Courses'),
      drawer: SideMenu(),
      body: enrolledCourses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: enrolledCourses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                        'Course Heading: ${enrolledCourses[index].heading}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subject: ${enrolledCourses[index].subject}'),
                        Text(
                            'Brief Description: ${enrolledCourses[index].description}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
