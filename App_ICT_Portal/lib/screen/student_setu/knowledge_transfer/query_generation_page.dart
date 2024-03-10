import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/components/custom_app_bar.dart';
import 'package:ict_portal/components/side_menu.dart';
import 'package:ict_portal/screen/student_setu/knowledge_transfer/Query.dart';

class QueryGenerationPage extends StatefulWidget {
  @override
  _QueryGenerationPageState createState() => _QueryGenerationPageState();
}

class _QueryGenerationPageState extends State<QueryGenerationPage> {
  TextEditingController headingController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for the form

  Future<void> submitQuery(Query query) async {
    final response = await http.post(
      Uri.parse(
          'http://172.30.48.1/ICT/API_ICT_Portal/insert_query.php'),
      body: {
        'heading': query.heading,
        'subject': query.subject,
        'description': query.description,
      },
    );

    if (response.statusCode == 200) {
      // Query successfully submitted
      print('Query submitted successfully!');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Query submitted successfully!'),
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
      // Error occurred while submitting query
      print('Error submitting query: ${response.body}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error submitting query. Please try again.'),
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
      appBar: CustomAppBar(title: 'Query Generation'),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key to the form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: headingController,
                decoration: InputDecoration(
                  labelText: 'Query Heading', // Label text without the asterisk
                  suffix: Text(
                    '*', // Asterisk
                    style: TextStyle(color: Colors.red), // Red color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Query Heading is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject', // Label text without the asterisk
                  suffix: Text(
                    '*', // Asterisk
                    style: TextStyle(color: Colors.red), // Red color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Subject is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText:
                      'Brief Description', // Label text without the asterisk
                  suffix: Text(
                    '*', // Asterisk
                    style: TextStyle(color: Colors.red), // Red color
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Brief Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Validate the form before submission
                  if (_formKey.currentState!.validate()) {
                    String heading = headingController.text;
                    String subject = subjectController.text;
                    String description = descriptionController.text;

                    Query newQuery = Query(
                      heading: heading,
                      subject: subject,
                      description: description,
                    );

                    submitQuery(newQuery);

                    // Clear text fields after submission
                    headingController.clear();
                    subjectController.clear();
                    descriptionController.clear();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
