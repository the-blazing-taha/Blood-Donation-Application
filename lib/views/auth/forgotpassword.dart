import 'package:blood/views/auth/registerscreen.dart';
import 'package:flutter/material.dart';
import '../../../controllers/auth_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late String email;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.white, // Change this color to your desired color
          ),
        ),
        backgroundColor: Colors.red[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                onChanged: (value) {
                  email = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email field must not be empty';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Enter Email Address',
                    hintText: 'Enter the Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.red[900],
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: ((){_authController.reset(email);}),
                  child: const Text("Send Link")),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RegisterScreen();
                      },
                    ),
                  );
                },
                child: const Text(
                  "Need an Account?",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
