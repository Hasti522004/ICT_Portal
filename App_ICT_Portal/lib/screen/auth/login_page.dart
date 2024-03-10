import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ict_portal/screen/home_page.dart'; // Import Flutter services for input formatting

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
        backgroundColor: Colors.blue, // Set app bar color
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
                      _isPasswordValid = _validatePassword(value);
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
                    _login();
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Set button color
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
                    _showForgotPasswordDialog();
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

  void _login() {
    // Validate inputs
    if (_enrollmentController.text.length != 11) {
      setState(() {
        _errorMessage = 'Please enter a valid 11-digit enrollment number.';
      });
      return;
    }
    if (!_isPasswordValid) {
      setState(() {
        _errorMessage = 'Please enter a valid password.';
      });
      return;
    }

    // Implement login logic here

    // Show success message
    final snackBar = SnackBar(
      content: Text('User logged in successfully!'),
      backgroundColor: Colors.green, // Set background color for the SnackBar
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password?'),
          content:
              Text('Please contact your administrator for password reset.'),
          actions: <Widget>[
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

  bool _validatePassword(String value) {
    // Password criteria: 8-10 characters, uppercase, lowercase, digit, special character
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?]).{8,10}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
