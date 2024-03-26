import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ict_portal/screen/interview_bank/interview_bank_student_model/Student.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;

  StudentDetailsPage({required this.student});

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
                'Student Name: ${student.id}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold), // Increased font size to 20
              ),
              SizedBox(height: 12), // Increased height
              Text(
                'Enrollment: ${student.enr}',
                style: TextStyle(fontSize: 16), // Increased font size to 16
              ),
              SizedBox(height: 12), // Increased height
              Text(
                'Company Name: ${student.title}',
                style: TextStyle(fontSize: 16), // Increased font size to 16
              ),
              SizedBox(height: 12), // Increased height
              Text(
                'Package: ${student.pack}',
                style: TextStyle(fontSize: 16), // Increased font size to 16
              ),
              SizedBox(height: 12), // Increased height
              Text(
                'Date: ${student.date}',
                style: TextStyle(fontSize: 16), // Increased font size to 16
              ),
              SizedBox(height: 12), // Increased height
              Text(
                'Interview Experience: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18), // Increased font size to 18
              ),
              SizedBox(height: 12), // Increased height
              Html(
                data: student.disc,
                style: {
                  "body": Style(
                      fontSize: FontSize(16)), // Increased font size to 16
                },
              ),
              SizedBox(height: 12), // Increased height
            ],
          ),
        ),
      ),
    );
  }
}
