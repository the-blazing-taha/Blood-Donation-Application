import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../controllers/databaseController.dart';


// class RequestForm extends StatefulWidget {
//   const RequestForm({super.key});
//
//   @override
//   State<RequestForm> createState() => _RequestFormState();
// }
class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

// class _RequestFormState extends State<RequestForm> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class _RequestFormState extends State<RequestForm> {
  String? _currentAddress;
  Position? _currentPosition;


  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }


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

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.subLocality}, '
            '${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }


  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String bloodGroup = '';
  String gender = '';
  int bags = 0;
  String hospital = '';
  String patient = "";
  String residence = "";
  String _case = "";
  String contact = "";
  String details = "";
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
  List<String> list = <String>[
    'Anemia',
    'Cancer',
    'Hemophilia',
    'Sickle cell disease'
  ];

  bool vertical = false;
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    String dropdownValue = list.first;

    return Scaffold(
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
                        setState(() {
                          patient=value;
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
                          contact=phone.completeNumber;
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
                      onChanged: (value){
                        hospital=value;
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
                              ?  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                              :  const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,width: 3,),
                              borderRadius:BorderRadius.all(Radius.circular(10.0))
                          ),

                        ),
                      ),
                      width: 325,
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        setState(() {
                          _case = value!;
                        });
                      },
                      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(value: value, label: value);
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
                        FilteringTextInputFormatter.digitsOnly, // Ensures only digits are entered
                      ],
                      onChanged: (value) {
                        setState(() {
                          // Safely parse the string to an integer
                          bags = int.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'e.g 3',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red[900]!, width: 3),
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
                      onChanged: (value){
                        setState(() {
                          details=value;
                        });
                      },
                      decoration: InputDecoration(
                        // label: const Text('Number of Bags'),
                        hintText: 'e.g I have been suffering a lot so kindly give me the blood.',
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
                                for (int i = 0; i < _selectedGenders.length; i++) {
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
                        onPressed:() async {
                          _databaseService.addRequest(patient, contact, hospital, residence, _case, bags, bloodGroup, gender);
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
      ),
    );
  }


}

