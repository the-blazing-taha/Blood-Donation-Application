import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class phoneVerification extends StatelessWidget {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  phoneVerification({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formkey,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome                           ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                'Please enter your phone number',
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              IntlPhoneField(
                decoration: InputDecoration(

                  labelText: "Enter Phone Number",

                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Red colored border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Red border color when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), // Red border color when enabled
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
