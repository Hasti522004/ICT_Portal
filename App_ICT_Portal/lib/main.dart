import 'package:flutter/material.dart';
import 'package:ict_portal/screen/home_page.dart';
import 'package:ict_portal/screen/user/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MaterialApp(
          title: 'ICT Promotion App',
          theme: ThemeData(
            primarySwatch: color(0xFF00A6BE),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ));
  }

  color(int i) {}
}
