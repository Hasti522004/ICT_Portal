import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';


class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  String selectedProfessor = '';
  TextEditingController feedbackController = TextEditingController();

  List<String> professors = [
    "Prof.Sunera Kargathara",
    "Prof.Kapil Shukla",
    "Prof.Dharmendrasinh Zala",
    "Prof.Kirankumar Parmar",
    "Prof.Mehulkumar Kantaria",
    "Prof.Chandrasinh Parmar",
    "Prof.Ami Pandat",
    "Prof.Krunal Vasani",
    "Prof.Urmi Shah",
    "Prof.Kishankumar Bhimani",
    "Prof.Hiren Raithatha",
    "Prof.Arjav Bavarva",
    "Prof.Sneha Khetiya",
    "Prof.Nishith Kotak",
    "Prof.Jayesh Dhandha",
    "Prof.Varun",
    "Prof.Test Jihj",
    "Prof.Kumar Anand",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Feedback Form'),
      drawer: SideMenu(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedProfessor.isNotEmpty ? selectedProfessor : null,
              items: professors.map((professor) {
                return DropdownMenuItem<String>(
                  value: professor,
                  child: Text(professor),
                );
              }).toList(),
              hint: Text('Select Professor'),
              onChanged: (value) {
                setState(() {
                  selectedProfessor = value ?? '';
                });
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Feedback',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                submitFeedback();
              },
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  void submitFeedback() async {
    String feedback = feedbackController.text;
    if (selectedProfessor.isEmpty || feedback.isEmpty) {
      // Show error message if professor or feedback is not selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select a professor and provide feedback.'),
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
      return;
    }

    String url =
        'http://192.168.137.1/dashboard/API_ICT_promotion/insert_feedback.php'; // Replace with your PHP API URL
    Map<String, String> data = {
      'professor': selectedProfessor,
      'feedback_text': feedback,
    };

    var response = await http.post(Uri.parse(url), body: data);

    if (response.statusCode == 200) {
      // Feedback submitted successfully
      print('Feedback submitted successfully!');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Feedback submitted successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  // Clear fields
                  setState(() {
                    selectedProfessor = '';
                    feedbackController.clear();
                  });
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Error submitting feedback
      print('Error submitting feedback: ${response.body}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error submitting feedback. Please try again later.'),
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
}
