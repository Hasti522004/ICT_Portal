import 'package:flutter/material.dart';
import 'package:ict_portal/screen/student_reward/student_reward_input_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICT Promotion App',
      theme: ThemeData(
        primarySwatch: color(0xFF00A6BE),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: StudentInfoPage(),
    );
  }

  color(int i) {}
}
