import 'dart:core';
import 'package:blood/controllers/auth_controller.dart';
import 'package:blood/views/auth/loginscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:show_hide_password/show_hide_password.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();
  TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late String email;
  late String password;
  late String fullName;

  bool isLoading = false;
  Uint8List? _image;

  bool vertical = false;

  void registerUser() async {
      if (formkey.currentState!.validate()) {
        if(mounted) {
          setState(() {
            isLoading = true;
          });
        }
        String res = await _authController.createNewUser(
            email: email, fullName: fullName,password: password,image: _image);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        if (res == 'success') {
          if(mounted) {
            setState(() {
              isLoading = true;
            });
          }
        } else {
          Get.snackbar("Error: ", res.toString(),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              margin: const EdgeInsets.all(
                15,
              ),
              snackPosition: SnackPosition.BOTTOM,
              icon: const Icon(
                Icons.message,
                color: Colors.white,
              ));
        }
      } else {
        Get.snackbar('Form', 'Form field not valid',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.all(
              15,
            ),
            icon: const Icon(
              Icons.message,
              color: Colors.white,
            ));
      }

  }

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);
    if (mounted) {
      setState(() {
        _image = im;
      });
    }
  }

  captureImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.camera);
    if (mounted) {
      setState(() {
        _image = im;
      });
    }
  }

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formkey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      _image == null
                          ? const CircleAvatar(
                              radius: 70,
                              child: Icon(
                                Icons.person,
                                size: 80,
                              ),
                            )
                          : CircleAvatar(
                              radius: 65,
                              backgroundImage: MemoryImage(_image!),
                            ),
                      Positioned(
                        right: 0,
                        top: -11,
                        child: IconButton(
                          onPressed: () {
                            selectGalleryImage();
                          },
                          icon: const Icon(CupertinoIcons.photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: _emailController,
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
                      hintText: 'Enter Email Address',
                      hintStyle:
                          Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: Colors.black38,
                                fontWeight: FontWeight.w600,
                              ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      fullName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name field must not be empty!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter Full Name',
                      hintStyle:
                          Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: Colors.black38,
                                fontWeight: FontWeight.w600,
                              ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ShowHidePassword(
                    hidePassword: true,
                    passwordField: (hidePassword) {
                      return TextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        keyboardType: TextInputType.text,
                        controller: controller,
                        obscureText: hidePassword,

                        ///use the hidePassword status on obscureText to toggle the visibility
                        showCursor: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.red[900],
                          ),
                          isDense: true,
                          labelText: 'Password',
                          hintText: 'Enter the password',
                          hintStyle:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w600,
                                  ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          counterText: "",
                          // contentPadding:EdgeInsets.symmetric(vertical: size.height*0.018,horizontal: size.width*0.04),
                        ),
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                      );
                    },
                    iconSize: 18,
                    visibleOffIcon: Iconsax.eye_slash,
                    visibleOnIcon: Iconsax.eye,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      registerUser();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.red[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 4),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: const Text(
                      'Already have an account?',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
