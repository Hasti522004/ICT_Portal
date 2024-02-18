import 'package:flutter/material.dart';
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/Course.dart';

class CourseDiscussionPage extends StatefulWidget {
  const CourseDiscussionPage({Key? key}) : super(key: key);

  @override
  _CourseDiscussionPageState createState() => _CourseDiscussionPageState();
}

class _CourseDiscussionPageState extends State<CourseDiscussionPage> {
  List<Course> askedCourses = [
    Course(
      heading: 'Course 1 Heading',
      subject: 'Course 1 Subject',
      description: 'Course 1 Description',
    ),
    Course(
      heading: 'Course 2 Heading',
      subject: 'Course 2 Subject',
      description: 'Course 2 Description',
    ),
  ];

  List<Course> repliedCourses = [
    Course(
      heading: 'Replied Course 1 Heading',
      subject: 'Replied Course 1 Subject',
      description: 'Replied Course 1 Description',
    ),
    Course(
      heading: 'Replied Course 2 Heading',
      subject: 'Replied Course 2 Subject',
      description: 'Replied Course 2 Description',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Course Discussion'),
      drawer: SideMenu(),
      body: Column(
        children: [
          _buildDiscussionList('Asked Courses', askedCourses),
          _buildDiscussionList('Replied Courses', repliedCourses),
        ],
      ),
    );
  }

  Widget _buildDiscussionList(String title, List<Course> courses) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Course Heading: ${courses[index].heading}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subject: ${courses[index].subject}'),
                        Text(
                          'Brief Description: ${courses[index].description}',
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
    );
  }
}
