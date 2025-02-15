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
  int countdown = 120; // 2 minutes
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
        if (countdown % 5 == 0) {
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
    await _auth.currentUser!.reload();
    if (_auth.currentUser!.emailVerified) {
      timer?.cancel();
      Get.offAll(() => const Wrapper());
    }
  }

  // Function to handle expired link
  Future<void> handleExpiredLink() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
        Get.to(() => const RegisterScreen());
      }
    } catch (e) {
      Get.snackbar(
        'Error', 'Failed to delete user: ${e.toString()}',
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Function to send the email verification link
  Future<void> sendVerifyLink() async {
    setState(() => isSending = true);
    try {
      final user = _auth.currentUser!;
      await user.sendEmailVerification();
      Get.snackbar(
        'Link Sent', 'A verification link has been sent to your email.',
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error', e.toString(),
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      backgroundColor: Colors.blueGrey[50], // Light background
      appBar: AppBar(
        title: const Text("Email Verification"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            shadowColor: Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.email, size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 20),
                  const Text(
                    "Verify Your Email",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "A verification link has been sent to your email. Please check your inbox and click the link to verify your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),

                  if (countdown > 0)
                    Text(
                      "Link expires in ${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                    ),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: checkVerification,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Check Verification"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: (isSending || countdown > 0) ? null : sendVerifyLink,
                    icon: isSending
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.email),
                    label: const Text("Resend Email"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
