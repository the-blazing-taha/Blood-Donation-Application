import 'dart:core';
import 'package:blood/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RequestDonor extends StatefulWidget {
  const RequestDonor({super.key});

  @override
  State<RequestDonor> createState() => _RequestDonorState();
}

class _RequestDonorState extends State<RequestDonor> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late String bloodGroup = '';
  late String gender = '';
  late int bags;

  final List<bool> _selectedGenders = <bool>[
    false,
    false,
  ];
  List<Widget> genders = <Widget>[
    const Icon(
      Icons.man,
      size: 40,
    ),
    const Icon(
      Icons.woman,
      size: 40,
    ),
  ];

  final List<bool> _selectedGroups = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<Widget> groups = <Widget>[
    const Text('A+'),
    const Text('B+'),
    const Text('AB+'),
    const Text('O+'),
    const Text('A-'),
    const Text('B-'),
    const Text('AB-'),
    const Text('O-'),
  ];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formkey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Patient Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Patient Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      // label: const Text('Number of Bags'),
                      hintText: 'e.g Mohammad Aliar',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.red[900]!, width: 2.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Contact',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IntlPhoneField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '3221040476',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[900]!),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[900]!),
                        borderRadius: BorderRadius.circular(
                            10), // Red border color when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[900]!),
                        borderRadius: BorderRadius.circular(
                            10), // Red border color when enabled
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hospital Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      // label: const Text('Number of Bags'),
                      hintText: 'e.g Lahore Children Hospital',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Residence',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      // label: const Text('Number of Bags'),
                      hintText: 'e.g House. 131, Street 2, Gulberg Sukh Chayn Gardens Lahore, District Kasur',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Number of donations done:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // label: const Text('Number of Bags'),
                      hintText: 'e.g 5',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bags',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // label: const Text('Number of Bags'),
                      hintText: 'e.g 3',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.red[900]!, width: 3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Blood Group',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 20.0, // Add spacing between buttons
                    runSpacing: 10.0, // Add spacing between rows
                    children: List<Widget>.generate(groups.length, (int index) {
                      return ChoiceChip(
                        shadowColor: Colors.black,
                        showCheckmark: false, // Remove the tick mark
                        label: groups[index],
                        selected: _selectedGroups[index],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1.0, vertical: 1.0), // Increase padding
                        onSelected: (bool selected) {
                          setState(() {
                            if (_selectedGroups[index] && !selected) {
                              // This block is executed when the chip is unselected
                              _selectedGroups[index] = false;
                              bloodGroup = '';
                            } else {
                              // Allow only one selection at a time
                              for (int i = 0; i < _selectedGroups.length; i++) {
                                _selectedGroups[i] = false;
                              }
                              _selectedGroups[index] = selected;
                              bloodGroup = (groups[index] as Text).data!;
                            }
                          });
                        },
                        side: BorderSide(
                          color: Colors.red[900]!,
                          width: 3.0, // Set the border thickness
                        ),
                        selectedColor: Colors.red[900],
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: _selectedGroups[index]
                              ? Colors.white
                              : Colors.red[900],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Gender',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 13.0, // Add spacing between buttons
                    runSpacing: 13.0, // Add spacing between rows
                    children:
                    List<Widget>.generate(genders.length, (int index) {
                      return ChoiceChip(
                        showCheckmark: false, // Remove the tick mark
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0), // Increase padding
                        label: genders[index],
                        selected: _selectedGenders[index],
                        onSelected: (bool selected) {
                          setState(() {
                            if (_selectedGenders[index] && !selected) {
                              // This block is executed when the chip is unselected
                              _selectedGenders[index] = false;
                              gender = '';
                            } else {
                              // Allow only one selection at a time
                              for (int i = 0;
                              i < _selectedGenders.length;
                              i++) {
                                _selectedGenders[i] = false;
                              }
                              _selectedGenders[index] = selected;
                              if (index == 0) {
                                gender = 'male';
                              } else if (index == 1) {
                                gender = 'female';
                              }
                            }
                          });
                        },
                        side: BorderSide(
                          color: Colors.red[900]!,
                          width: 3.0, // Set the border thickness
                        ),
                        selectedColor: Colors.red[900],
                        backgroundColor: Colors.white,
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: ()async{
                        // Respond to button press
                        // await DBHandeler().insertData(bloodGroup, gender, bags, hospital, patient, residence, _case, contact);
                        // final data = DBHandeler().readData();
                        // print(data);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red[900], // Background color
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                        elevation: 5, // Shadow elevation
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18, // Font size
                          fontWeight: FontWeight.bold, // Font weight
                        ),
                      ),
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
