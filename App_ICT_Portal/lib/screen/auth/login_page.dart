import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ict_portal/screen/home_page.dart';
import 'package:ict_portal/screen/user/User.dart';
import 'package:ict_portal/screen/user/user_provider.dart';
import 'package:provider/provider.dart'; // Import Flutter services for input formatting

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _enrollmentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _errorMessage = '';
  bool _isPasswordValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock), // Lock icon for visual appeal
              SizedBox(width: 8), // Add some spacing between icon and text
              Text('Login'), // Title text
            ],
          ),
        ),
        backgroundColor: Color(0xFF00A6BE), // Set app bar color
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5, // Add elevation for a shadow effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _enrollmentController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]')), // Allow only digits
                  ],
                  maxLength: 11,
                  decoration: InputDecoration(
                    labelText: 'Enrollment Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  onChanged: (value) {
                    setState(() {
                      // _isPasswordValid = _validatePassword(value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText:
                        '8-10 characters, uppercase, lowercase, digit, special character',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffix: _isPasswordValid
                        ? Icon(Icons.check,
                            color: Colors
                                .green) // Show green checkmark if password is valid
                        : null,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00A6BE), // Set button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Implement reset password logic here
                    // _showForgotPasswordDialog();
                  },
                  child: Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final enrollment = _enrollmentController.text;
    final password = _passwordController.text;

    final url = Uri.parse(
        'https://www.ictmu.in/ict_portal/api/student.php?key=student@ict');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        bool isLoggedIn = false;

        for (var item in data) {
          final studentEnroll = item['enroll'];
          final studentPswd = item['pswd'];

          if (studentEnroll == enrollment && studentPswd == password) {
            isLoggedIn = true;
            break;
          }
        }

        if (isLoggedIn) {
          final snackBar = SnackBar(
            content: Text('User logged in successfully!'),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          // Assuming successful login, set the user
          User user = User(enrollment: enrollment, password: password);
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          setState(() {
            _errorMessage = 'Invalid enrollment number or password.';
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Failed to connect to the server. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Network error occurred. Please check your internet connection.';
      });
    }
  }
}
