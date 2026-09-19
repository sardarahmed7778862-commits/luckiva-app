import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'LUCKIVA TEST',
          style: TextStyle(color: Colors.green, fontSize: 40),
        ),
      ),
    ),
  ));
}
