import 'package:flutter/material.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INQUADRATO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Bitcount Single'),
      home: const FakeLoginPage(),
    );
  }
}
