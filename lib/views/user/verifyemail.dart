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
  bool isSending = false; // To manage the button state

  @override
  void initState() {
    sendVerifyLink(); // Automatically send link on page load
    super.initState();
  }

  // Function to send the email verification link
  Future<void> sendVerifyLink() async {
    setState(() {
      isSending = true; // Disable button while sending
    });

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
      setState(() {
        isSending = false; // Re-enable button
      });
    }
  }

  // Function to reload the user and navigate to Wrapper
  Future<void> reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
    Get.offAll(() => const Wrapper());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(28.0),
        child: Center(
          child: Text("Open your email and click the verification link!"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "reload", // To differentiate between multiple FABs
            onPressed: reload,
            tooltip: "Reload",
            child: const Icon(Icons.restart_alt_rounded),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: "sendAgain", // Unique tag for the second button
            onPressed: isSending ? null : sendVerifyLink,
            tooltip: "Send Link Again", // Disable when sending
            child: isSending
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(Icons.email),
          ),
        ],
      ),
    );
  }
}
