import 'package:blood/views/auth/loginscreen.dart';
import 'package:blood/views/user/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class About extends StatefulWidget {

  const About({super.key});
  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("About Page")
    );
  }
}


