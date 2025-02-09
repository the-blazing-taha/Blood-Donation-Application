import 'dart:core';
import 'package:blood/controllers/fireStoreDatabaseController.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../controllers/databaseController.dart';
import '../admin/blood_appeal_admin.dart';
import 'home.dart';
import 'my_requests.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late String bloodGroup;
  late String gender;
  late int bags;
  late String hospital;
  late String patient;
  late String residence;
  late String donationCase;
  late String contact;
  late String details;
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
  static List<String> list = <String>[
    'None',
    'Anemia',
    'Cancer',
    'Hemophilia',
    'Sickle cell disease'
  ];
  bool vertical = false;
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController _locationController = TextEditingController();
  final fireStoreDatabaseController _firebaseDatabase = fireStoreDatabaseController();

  late String _currentAddress;
  Position? _currentPosition;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    signout() {
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Request Form",
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
                selected: selectedIndex == 0,
                onTap: () {
                  onItemTapped(0);
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
                selected: selectedIndex == 1,
                onTap: () {
                  onItemTapped(1);
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
                selected: selectedIndex == 2,
                onTap: () {
                  onItemTapped(2);
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
                selected: selectedIndex == 3,
                onTap: () {
                  onItemTapped(3);
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
                selected: selectedIndex == 4,
                onTap: () {
                  onItemTapped(4);
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
                selected: selectedIndex == 5,
                onTap: () {
                  onItemTapped(5);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
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
                selected: selectedIndex == 6,
                onTap: () {
                  onItemTapped(6);
                  Navigator.pop(context);
                  signout();
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
                      'Patient Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                        setState(() {
                          patient = value;
                        });
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
                            await _getCurrentPosition(); // Ensure position is fetched first
                            if (_currentAddress.isNotEmpty) {
                              setState(() {
                                _locationController.text = _currentAddress;
                                residence = _currentAddress;
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
                        'Case',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownMenu<String>(
                      inputDecorationTheme: InputDecorationTheme(
                        border: MaterialStateOutlineInputBorder.resolveWith(
                          (states) => states.contains(WidgetState.focused)
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
                      initialSelection: list.first,
                      onSelected: (value) {
                        setState(() {
                          donationCase = value!;
                        });
                      },
                      dropdownMenuEntries:
                          list.map<DropdownMenuEntry<String>>((String value) {
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
                        'Bags',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Ensures only digits are entered
                      ],
                      onChanged: (value) {
                        setState(() {
                          // Safely parse the string to an integer
                          bags = int.tryParse(value) ??
                              0; // If parsing fails, it will default to 0
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'e.g 3',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red[900]!, width: 3),
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
                        'Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          details = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText:
                            'e.g I have been suffering a lot so kindly give me the blood.',
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
                      children:
                          List<Widget>.generate(groups.length, (int index) {
                        return ChoiceChip(
                          shadowColor: Colors.black,
                          showCheckmark: false, // Remove the tick mark
                          label: groups[index],
                          selected: _selectedGroups[index],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1.0,
                              vertical: 1.0), // Increase padding
                          onSelected: (bool selected) {
                            setState(() {
                              if (_selectedGroups[index] && !selected) {
                                // This block is executed when the chip is unselected
                                _selectedGroups[index] = false;
                                bloodGroup = '';
                              } else {
                                // Allow only one selection at a time
                                for (int i = 0;
                                    i < _selectedGroups.length;
                                    i++) {
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
                                  gender = 'Male';
                                } else if (index == 1) {
                                  gender = 'Female';
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
                        onPressed: () async {
                          if (donationCase != "None") {
                            _databaseService.addRequest(
                                patient,
                                contact,
                                hospital,
                                residence,
                                donationCase,
                                bags,
                                bloodGroup,
                                gender,
                                details);
                            _firebaseDatabase.addRequest(patient, contact, hospital, residence, donationCase, bags, bloodGroup, gender, details);
                          } else {
                            print("ERROR: Case of donation not selected!");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red[900], // Background color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
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
      ),
    );
  }
}
