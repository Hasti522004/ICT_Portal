import 'package:flutter/material.dart';
import 'package:ict_portal/screen/interview_bank/Student.dart';

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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Enrollment: ${student.enr}'),
              SizedBox(height: 8),
              Text('Company Name: ${student.title}'),
              SizedBox(height: 8),
              Text('Package: ${student.pack}'),
              SizedBox(height: 8),
              Text('Date: ${student.date}'),
              SizedBox(height: 8),
              Text(
                'Interview Experience: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('${student.disc}'),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
