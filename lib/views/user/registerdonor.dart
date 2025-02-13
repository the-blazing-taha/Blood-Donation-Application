import 'dart:core';
import 'package:blood/views/user/globals.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/fireStoreDatabaseController.dart';
import 'home.dart';
import 'my_donation_appeal.dart';
import 'my_requests.dart';

class RequestDonor extends StatefulWidget {
  const RequestDonor({super.key});

  @override
  State<RequestDonor> createState() => _RequestDonorState();
}

class _RequestDonorState extends State<RequestDonor> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late String name ;
  late String hospital ;
  late String residence;
  late String contact;
  late int noOfDonation;
  late String bloodGroup ;
  late String gender;
  late String details;
  late int weight;
  late int age;
  late String lastDonated;
  late String donationFrequency;
  late String highestEducation;
  late String currentOccupation;
  late String currentLivingArrg;
  late String eligibilityTest;
  late String futureDonationWillingness;

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

  static List<String> last_donated = <String>[
    'Within last month',
    'Within Last 3 months',
    'Within Last 6 months',
    'Last year'
  ];

  static List<String> donation_frequency = <String>[
    'Once every 3 months',
    'Once every 6 months',
    'Once a year',
    'Less than once a year'
  ];

  static List<String> highest_education = <String>[
    'Less than Matriculation',
    'Matriculation',
    'High School',
    'Bachelors Degree',
    'Masters Degree',
    'PhD'
  ];

  static List<String> occupation = <String>[
    'Student',
    'Soldier',
    'Public functionary',
    'Medical staff',
    'Industrial',
    'Farmer',
    'Clerk',
    'Teacher'
  ];

  static List<String> living_arrangement = <String>[
    'Registered Residence',
    'Non-registered Residence'
  ];

  static List<String> bloodTest = <String>['Yes', 'No'];
  final FirebaseAuth auth = FirebaseAuth.instance;
  static List<String> future_donation = <String>['Yes', 'No'];
  final TextEditingController _locationController = TextEditingController();

  bool vertical = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final fireStoreDatabaseController _firebaseDatabase = fireStoreDatabaseController();
  final AuthController authController = AuthController();

  late String _currentAddress;
  Position? _currentPosition;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('Location services are disabled. Please enable them.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar('Location permissions are denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar('Location permissions are permanently denied. Please enable them in settings.');
      return false;
    }

    return true;
  }

  Future<String?> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _currentPosition = position; // ✅ Directly update position
      return await _getAddressFromLatLng(position); // ✅ Fetch and return address
    } catch (e) {
      debugPrint("Error fetching location: $e");
      return null;
    }
  }

  Future<String?> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      Placemark place = placemarks.first;

      String fullAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

      _currentAddress = fullAddress; // ✅ Update global variable
      return fullAddress; // ✅ Return address
    } catch (e) {
      debugPrint("Error fetching address: $e");
      return null;
    }
  }

// ✅ Utility function to show snackbars
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                  Icons.format_align_center,
                  color: Colors.white,
                ),
                title: const Text('My Donation Appeal',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: _selectedIndex == 4,
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DonationAppeal(),
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
                selected: _selectedIndex == 5,
                onTap: () {
                  _onItemTapped(5);
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
                selected: _selectedIndex == 6,
                onTap: () {
                  _onItemTapped(6);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  Profile(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text('Log Out',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: _selectedIndex == 7,
                onTap: () {
                  _onItemTapped(7);
                  Navigator.pop(context);
                  authController.signout();
                  setState(() {

                  });
                },
              ),
              // Other ListTiles...
            ],
          ),
        ),
      ),




      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                          onChanged: (value) {
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
                          initialCountryCode: 'PK',
                          onChanged: (phone) {
                            setState(() {
                              contact = phone.completeNumber;
                            });
                          },
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
                          onChanged: (value) {
                            hospital = value;
                          },
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
                          controller: _locationController,
                          onChanged: (value) {
                            setState(() {
                              residence = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText:
                            'e.g House. 131, Street 2, Gulberg Sukh Chayn Gardens Lahore, District Kasur',
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
                            suffixIcon: IconButton(
                              icon: Icon(Icons.my_location, color: Colors.red[900]),
                              onPressed: () async {
                                String? address = await _getCurrentPosition(); // ✅ Fetch location
                                if (address != null) {
                                  setState(() {
                                    _locationController.text = address; // ✅ Update TextFormField immediately
                                    residence = address;
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            details = value;
                          },
                          decoration: InputDecoration(
                            // label: const Text('Number of Bags'),
                            hintText: 'I really am a passionate donor',
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
                          onChanged: (value) {
                            noOfDonation = int.tryParse(value) ??
                                0; // If parsing fails, it will default to 0
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Your Weight (KG):',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            weight = int.tryParse(value) ??
                                0; // If parsing fails, it will default to 0
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'e.g 3',
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Your age (Years):',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            age = int.tryParse(value) ??
                                0; // If parsing fails, it will default to 0
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'e.g 22',
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Last Donated:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownMenu<String>(
                          inputDecorationTheme: InputDecorationTheme(
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                  (states) =>
                              states.contains(WidgetState.focused)
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))
                                  : const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                          width: 325,
        
        
                          onSelected: (value) {
                            setState(() {
                              lastDonated = value!;
                            });
                          },
                          dropdownMenuEntries: last_donated
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Blood Donation Frequency:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownMenu<String>(
                          inputDecorationTheme: InputDecorationTheme(
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                  (states) =>
                              states.contains(WidgetState.focused)
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))
                                  : const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                          width: 325,
        
                          onSelected: (value) {
                            setState(() {
                              donationFrequency = value!;
                            });
                          },
                          dropdownMenuEntries: donation_frequency
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Highest level of education:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownMenu<String>(
                          inputDecorationTheme: InputDecorationTheme(
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                  (states) =>
                              states.contains(WidgetState.focused)
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))
                                  : const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                          width: 325,
                          onSelected: (value) {
                            setState(() {
                              highestEducation = value!;
                            });
                          },
                          dropdownMenuEntries: highest_education
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Current Occupation:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownMenu<String>(
                          inputDecorationTheme: InputDecorationTheme(
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                  (states) =>
                              states.contains(WidgetState.focused)
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))
                                  : const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                          width: 325,
                          onSelected: (value) {
                            setState(() {
                              currentOccupation = value!;
                            });
                          },
                          dropdownMenuEntries: occupation
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Living Arrangement:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownMenu<String>(
                          inputDecorationTheme: InputDecorationTheme(
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                  (states) =>
                              states.contains(WidgetState.focused)
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))
                                  : const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                          width: 325,
        
                          onSelected: (value) {
                            setState(() {
                              currentLivingArrg = value!;
                            });
                          },
                          dropdownMenuEntries: living_arrangement
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Will you donate in future?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownMenu<String>(
                          inputDecorationTheme: InputDecorationTheme(
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                  (states) =>
                              states.contains(WidgetState.focused)
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))
                                  : const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                          width: 325,
        
                          onSelected: (value) {
                            setState(() {
                              futureDonationWillingness = value!;
                            });
                          },
                          dropdownMenuEntries: future_donation
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Have you passed a blood test for donation eligibility in the last 6 months?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownMenu<String>(
                          inputDecorationTheme: InputDecorationTheme(
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                  (states) =>
                              states.contains(WidgetState.focused)
                                  ? const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))
                                  : const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                          width: 325,
                          onSelected: (value) {
                            setState(() {
                              eligibilityTest = value!;
                            });
                          },
                          dropdownMenuEntries: bloodTest
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
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
                          children: List<Widget>.generate(
                              groups.length, (int index) {
                            return ChoiceChip(
                              shadowColor: Colors.black,
                              showCheckmark: false,
                              // Remove the tick mark
                              label: groups[index],
                              selected: _selectedGroups[index],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1.0, vertical: 1.0),
                              // Increase padding
                              onSelected: (bool selected) {
                                setState(() {
                                  if (_selectedGroups[index] && !selected) {
                                    // This block is executed when the chip is unselected
                                    _selectedGroups[index] = false;
                                    bloodGroup = '';
                                  } else {
                                    // Allow only one selection at a time
                                    for (int i = 0; i <
                                        _selectedGroups.length; i++) {
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
                              showCheckmark: false,
                              // Remove the tick mark
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 20.0),
                              // Increase padding
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
                          child: StreamBuilder<bool>(
                            stream: _firebaseDatabase.doesDonorExist(auth.currentUser!.uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Show loading indicator
                              }

                              bool donorExists = snapshot.data ?? false; // Default to false if no data yet

                              return ElevatedButton(
                                onPressed: donorExists
                                    ? null // Disable button if donor exists
                                    : () async {
                                  try {
                                    await _firebaseDatabase.addDonor(
                                        name, contact, hospital, residence, noOfDonation, bloodGroup,
                                        gender, details, weight, age, lastDonated, donationFrequency,
                                        highestEducation, currentOccupation, currentLivingArrg,
                                        eligibilityTest, futureDonationWillingness
                                    );

                                    setState(() {donorMode = true;});

                                    Get.snackbar('Success', 'Donor added successfully!',
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        margin: const EdgeInsets.all(15),
                                        icon: const Icon(Icons.check, color: Colors.white));

                                  } catch (e) {
                                    Get.snackbar('ERROR', e.toString(),
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        margin: const EdgeInsets.all(15),
                                        icon: const Icon(Icons.error, color: Colors.white));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: donorExists ? Colors.grey : Colors.red[900], // Grey when disabled
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  donorExists ? 'Already Registered' : 'Submit',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
            )
        ),
      ),
    );
  }
}
