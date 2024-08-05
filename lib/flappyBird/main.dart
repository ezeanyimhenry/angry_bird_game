// calls the Homescreen object of the file Hpage.dart
import 'package:flutter/material.dart';
import 'Hpage.dart';

void main() {
  runApp(Mygame());
}

class Mygame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // for removing the red DEBUG banner on top right of the screen
      home: Hpage(), // Home Page
    );
  }
}
