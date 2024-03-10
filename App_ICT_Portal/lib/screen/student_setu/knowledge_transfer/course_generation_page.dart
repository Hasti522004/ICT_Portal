import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/Course.dart';

class CourseGenerationPage extends StatefulWidget {
  @override
  _CourseGenerationPageState createState() => _CourseGenerationPageState();
}

class _CourseGenerationPageState extends State<CourseGenerationPage> {
  TextEditingController courseHeadingController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Course> generatedCourses = []; // List to store generated courses
  final _formKey = GlobalKey<FormState>(); // Key for the form

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> submitCourse(Course course) async {
    final response = await http.post(
      Uri.parse(
          'http://172.30.48.1/ICT/API_ICT_Portal/insert_course.php'),
      body: {
        'heading': course.heading,
        'subject': course.subject,
        'description': course.description,
      },
    );

    if (response.statusCode == 200) {
      print('Course submitted successfully!');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Course submitted successfully!'),
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
    } else {
      print('Error submitting course: ${response.body}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error submitting course. Please try again.'),
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
      appBar: CustomAppBar(title: 'Course Generation'),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: courseHeadingController,
                decoration: InputDecoration(labelText: 'Course Heading'),
                validator: validateField,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: validateField,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Brief Description'),
                maxLines: 4,
                validator: validateField,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String courseHeading = courseHeadingController.text;
                    String subject = subjectController.text;
                    String description = descriptionController.text;

                    Course newCourse = Course(
                        heading: courseHeading,
                        subject: subject,
                        description: description);

                    submitCourse(newCourse);

                    courseHeadingController.clear();
                    subjectController.clear();
                    descriptionController.clear();
                  }
                },
                child: Text('Generate Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
