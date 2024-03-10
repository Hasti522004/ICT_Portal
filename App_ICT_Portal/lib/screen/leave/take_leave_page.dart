import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LeavePage extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  String? _selectedCategory;
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _fileName;
  bool _isLoading = false;

  TextEditingController _reasonController = TextEditingController();

  void _pickFile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.first.name;
        });
      } else {
        setState(() {
          _fileName = null;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearFile() {
    setState(() {
      _fileName = null;
    });
  }

  void _submitLeaveApplication() async {
    String apiUrl = 'http://192.168.137.1/ICT/API_ICT_Portal/insert_leave.php';

    String category = _selectedCategory ?? '';
    String fromDate =
        _fromDate != null ? DateFormat('yyyy-MM-dd').format(_fromDate!) : '';
    String toDate =
        _toDate != null ? DateFormat('yyyy-MM-dd').format(_toDate!) : '';
    String reason = _reasonController.text;
    String fileUrl = _fileName ?? '';

    Map<String, dynamic> body = {
      'category': category,
      'from_date': fromDate,
      'to_date': toDate,
      'reason': reason,
      'file_url': fileUrl,
    };

    try {
      setState(() {
        _isLoading = true;
      });
      final response = await http.post(Uri.parse(apiUrl), body: body);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success']) {
          _showResponseDialog('Leave application submitted successfully');
        } else {
          _showResponseDialog(
              'Failed to submit leave application: ${responseData['message']}');
        }
      } else {
        _showResponseDialog('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showResponseDialog('Error sending request: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showResponseDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave Application'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildDateField({
    required String labelText,
    required DateTime? date,
    required void Function() onTap,
  }) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: date == null ? '' : DateFormat('yyyy-MM-dd').format(date!),
      ),
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          onPressed: onTap,
          icon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = selectedDate;
        } else {
          _toDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Application'),
        backgroundColor: Color(0xFF00A6BE),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: ['Personal', 'Educational', 'Medical', 'Other']
                  .map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Category',
              ),
            ),
            SizedBox(height: 16.0),
            buildDateField(
              labelText: 'From Date (YYYY-MM-DD)',
              date: _fromDate,
              onTap: () => _selectDate(context, true),
            ),
            SizedBox(height: 16.0),
            buildDateField(
              labelText: 'To Date (YYYY-MM-DD)',
              date: _toDate,
              onTap: () => _selectDate(context, false),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Reason',
              ),
              onChanged: (value) {
                setState(() {
                  var _reason = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: _isLoading ? null : _pickFile,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Choose File',
                        style: TextStyle(
                          color: _isLoading
                              ? Colors.grey
                              : const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.attach_file,
                    color:
                        _isLoading ? Colors.grey : Color.fromARGB(255, 0, 0, 0),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _fileName != null
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Selected file: $_fileName',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: _clearFile,
                            icon: Icon(Icons.clear),
                          ),
                        ],
                      )
                    : Container(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitLeaveApplication,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
