import 'package:flutter/material.dart';
import 'package:flutter_http_exp/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const  AppBarTheme(elevation: 0.0,color: Colors.white)
      ),
      home: const HomePage(),
    );
  }
}
