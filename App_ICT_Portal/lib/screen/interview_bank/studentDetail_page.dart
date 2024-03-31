import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ict_portal/screen/interview_bank/interview_bank_student_model/Student.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;
  final String studentName;

  StudentDetailsPage({required this.studentName, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interview Details"),
        backgroundColor: Color(0xFF00A6BE),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Name: $studentName',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Enrollment: ${student.enr}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'Company Name: ${student.title}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'Package: ${student.pack}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'Date: ${student.date}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Divider(
                height: 20,
                thickness: 2,
                color: Colors.grey[400],
              ),
              SizedBox(height: 12),
              Text(
                'Interview Experience: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 12),
              Html(
                data: student.disc,
                style: {
                  "body": Style(fontSize: FontSize(16)),
                },
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
