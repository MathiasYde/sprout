import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenleaf/pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sprout",
      theme: ThemeData(
        primaryColor: Color(0xFF00FF00),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Homepage(title: "Sprout"),
    );
  }
}
