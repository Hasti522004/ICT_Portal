import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/screen/interview_bank/interviewbank_page.dart';
import 'package:intl/intl.dart'; // Import the intl package

class InterviewForm extends StatefulWidget {
  @override
  _InterviewFormState createState() => _InterviewFormState();
}

class _InterviewFormState extends State<InterviewForm> {
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController enrollmentController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController packageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? categoryValue;
  String? packageValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interview Details"),
        backgroundColor: Color(0xFF00A6BE),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: studentNameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Student name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: enrollmentController,
                decoration: InputDecoration(labelText: 'Enrollment Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enrollment number is required';
                  }
                  if (value.length != 11) {
                    return 'Enrollment number must be 11 digits';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: packageController,
                decoration: InputDecoration(labelText: 'Package (x-y)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Package is required';
                  }
                  final RegExp packageRegex =
                      RegExp(r'^\d+(\.\d+)?\s*-\s*\d+(\.\d+)?$');
                  if (!packageRegex.hasMatch(value)) {
                    return 'Invalid package format';
                  }
                  return null;
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.0),
              InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    dateController.text = formattedDate;
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: categoryValue,
                onChanged: (newValue) {
                  setState(() {
                    categoryValue = newValue;
                  });
                },
                items: ['Mock', 'Technical', 'HR', 'Technical + HR']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                // This TextFormField replaces the HtmlEditor widget
                controller:
                    descriptionController, // You can keep or remove this controller based on your needs
                maxLines: 10, // Adjust the number of lines as needed
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description here',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If all validations pass, submit the form
                    submitInterview();
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

  void submitInterview() async {
    String url = 'http://192.168.137.1/ICT/API_ICT_Portal/insert_interview.php';
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };

    String body = "student_name=${studentNameController.text}"
        "&enrollment_number=${enrollmentController.text}"
        "&company_name=${companyNameController.text}"
        "&package=${packageController.text}"
        "&date=${dateController.text}"
        "&category=${categoryValue}"
        "&description=${descriptionController.text}";

    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content:
                Text('Interview details have been successfully submitted.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate to interviewbank_page
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InterviewBankPage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Error storing data in the database
      print("Error storing data: ${response.body}");
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to store interview details. Please try again later.'),
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
