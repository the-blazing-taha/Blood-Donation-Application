import 'package:blood/views/auth/loginscreen.dart';
import 'package:blood/views/user/home.dart';
import 'package:blood/views/user/splash_screen.dart';
import 'package:blood/views/user/verifyemail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class Wrapper extends StatefulWidget {

  const Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.emailVerified){
                  return const SplashScreen();
                }
                else{
                  return const VerifyEmail();
                }
              }
              else{
                return const LoginScreen();
              }
            })
    );
  }
}