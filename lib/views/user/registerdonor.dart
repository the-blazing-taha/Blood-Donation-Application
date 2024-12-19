import 'dart:core';
import 'package:blood/controllers/auth_controller.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controllers/databaseController.dart';
import 'donors_list.dart';
import 'home.dart';
import 'my_donation_appeal.dart';
import 'my_requests.dart';

class RequestDonor extends StatefulWidget {
  const RequestDonor({super.key});

  @override
  State<RequestDonor> createState() => _RequestDonorState();
}

class _RequestDonorState extends State<RequestDonor> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late String name='';
  late String hospital ='';
  late String residence = '';
  late String contact = '';
  late int noOfDonation;
  late String bloodGroup = '';
  late String gender = '';

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
  final DatabaseService _databaseService = DatabaseService.instance;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register as donor",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 10,
            padding: const EdgeInsets.all(1.0),
            onPressed: () {},
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          )
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        backgroundColor: Colors.red[900],
        centerTitle: true,
      ),
      drawer: Opacity(
        opacity: 0.6,
        child: Drawer(
          backgroundColor: Colors.red[900],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red[900],
                ),
                child: const Text(
                  'Life Sync',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.bloodtype_sharp,
                  color: Colors.white,
                ),
                title: const Text(
                  'Your Requests',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Requests(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                title: const Text(
                  'All Donors',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                selected: _selectedIndex == 2,
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DonorList(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: const Text('Register as Donor',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: _selectedIndex == 3,
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestDonor(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.request_page,
                  color: Colors.white,
                ),
                title: const Text('Add Blood Request',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: _selectedIndex == 4,
                onTap: () {
                  _onItemTapped(4);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestForm(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.request_page,
                  color: Colors.white,
                ),
                title: const Text('Profile',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: _selectedIndex == 5,
                onTap: () {
                  _onItemTapped(5);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
              ),
              // Other ListTiles...
            ],
          ),
        ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Donor Form',
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
                    onChanged: (value){
                      name = value;
                    },
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
                    onChanged: (phone) {
                      setState(() {
                        contact=phone.completeNumber;
                      });
                    },
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
                    onChanged: (value){
                      residence=value;
                    },
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
                    onChanged: (value){
                      noOfDonation = int.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
                        _databaseService.addDonation(name, contact, hospital, residence, noOfDonation, bloodGroup, gender);
                        setState(() {

                        });
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
