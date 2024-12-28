import 'package:blood/views/user/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  void initState() {
    sendVerifyLink();
    super.initState();
  }

  sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) => {
          Get.snackbar('Link sent', 'A link has been sent to your email',
              margin: const EdgeInsets.all(30),
              snackPosition: SnackPosition.BOTTOM)
        });
  }
  reload()async{
    await FirebaseAuth.instance.currentUser!.reload().then((value)=>{Get.offAll(const Wrapper())});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email"),),
      body: const Padding(
        padding: EdgeInsets.all(28.0),
        child: Center(child: Text("Open Your email and click verify link!")),
      ),

      floatingActionButton: FloatingActionButton(onPressed: (()=>reload()),
      child: const Icon(Icons.restart_alt_rounded),),

    );
  }
}
