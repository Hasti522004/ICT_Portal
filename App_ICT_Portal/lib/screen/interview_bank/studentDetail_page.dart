import 'package:flutter/material.dart';
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/interview_bank/Student.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;

  StudentDetailsPage({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Interview Details'),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Name: ${student.studentName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Enrollment: ${student.enrollment}'),
            SizedBox(height: 8),
            Text('Company Name: ${student.companyName}'),
            SizedBox(height: 8),
            Text('Package: ${student.package}'),
            SizedBox(height: 8),
            Text('Date: ${student.date}'),
            SizedBox(height: 8),
            Text(
              'Interview Experience: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${student.interviewExperience}'),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
