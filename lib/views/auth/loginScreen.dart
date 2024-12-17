import 'package:blood/views/auth/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  bool _isObscured = true;
  late String email;
  late String password;
  bool isLoading = false;

  loginUser() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String res = await _authController.loginUser(email, password);
      setState(() {
        isLoading = false;
      });
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
          'Login Success',
          'You have logged in!',
          colorText: Colors.white,
          backgroundColor: Colors.red[900],
        );
      } else {
        Get.snackbar(
          'Login Failed',
          res.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[900],

        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log in',
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
                    labelText: 'Email Address',
                    hintText: 'Enter the Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.red[900],
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
        TextFormField(
          onChanged: (value) {
            password = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password field must not be empty';
            } else {
              return null;
            }
          },
          obscureText: _isObscured, // Use the visibility state
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter the password',
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.red[900],
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured; // Toggle the visibility state
                });
              },
            ),
          ),
        ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  loginUser();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.red[900],
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Center(
                    child: isLoading? const CircularProgressIndicator(color: Colors.white,): const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
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
