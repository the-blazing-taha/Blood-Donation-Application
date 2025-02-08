import 'dart:async';
import 'package:blood/views/auth/registerscreen.dart';
import 'package:blood/views/user/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isSending = false;
  int countdown = 20; // 5 minutes
  Timer? timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    sendVerifyLink();
    startCountdown();
  }

  // Function to start countdown
  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (countdown > 0) {
        setState(() => countdown--);
        if (countdown % 5 == 0) { // Check verification only every 5 seconds
          await checkVerification();
        }
      } else {
        timer.cancel();
        handleExpiredLink();
      }
    });
  }


  // Function to check email verification status
  Future<void> checkVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      timer?.cancel();
      Get.offAll(() => const Wrapper());
    }
  }

  // Function to handle expired link
  Future<void> handleExpiredLink() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser?.uid).delete();
        Get.to(RegisterScreen()); // Move navigation inside try block
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: ${e.toString()}',
          margin: const EdgeInsets.all(30),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }


  // Function to send the email verification link
  Future<void> sendVerifyLink() async {
    // if (isSending || countdown > 0) return;
    setState(() => isSending = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      Get.snackbar('Link Sent', 'A link has been sent to your email.',
          margin: const EdgeInsets.all(30),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          margin: const EdgeInsets.all(30),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      setState(() => isSending = false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Open your email and click the verification link!"),
            if (countdown > 0)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Link expires in ${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "reload",
            onPressed: checkVerification,
            tooltip: "Reload",
            child: const Icon(Icons.restart_alt_rounded),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: "sendAgain",
            onPressed: (isSending || countdown > 0) ? null : sendVerifyLink,
            tooltip: "Send Link Again",
            child: isSending
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.email),
          ),
        ],
      ),
    );
  }
}
