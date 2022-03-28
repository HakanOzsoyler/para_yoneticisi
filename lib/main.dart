import 'package:flutter/material.dart';
import 'package:flutter_para_yoneticisi/screen/home_page.dart';
import 'package:flutter_para_yoneticisi/utils/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var databaseHelper = DatabaseHelper();
    databaseHelper.categoryRead();
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
