import 'dart:core';
import 'package:blood/controllers/fireStoreDatabaseController.dart';
import 'package:blood/views/user/drawer.dart';
import 'package:blood/views/user/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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

  final List<bool> _selectedGenders = <bool>[false, false];
  final List<Widget> genders = <Widget>[
    const Icon(Icons.man, size: 40),
    const Icon(Icons.woman, size: 40),
  ];

  final List<bool> _selectedGroups = <bool>[false, false, false, false, false, false, false, false];
  final List<Widget> groups = <Widget>[
    const Text('A+'),
    const Text('B+'),
    const Text('AB+'),
    const Text('O+'),
    const Text('A-'),
    const Text('B-'),
    const Text('AB-'),
    const Text('O-'),
  ];

  static const List<String> list = <String>[
    'None',
    'Anemia',
    'Cancer',
    'Hemophilia',
    'Sickle cell disease',
    'Weakness',
    'Operational Blood loss'
  ];

  final TextEditingController _locationController = TextEditingController();
  final fireStoreDatabaseController _firebaseDatabase = fireStoreDatabaseController();

  late String _currentAddress;
  Position? _currentPosition;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoadingLocation = false; // State to track loading
  bool isLoading = false; // State to track loading for submission

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('Location services are disabled. Please enable the services');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar('Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _currentPosition = position;
      await _getAddressFromLatLng(position);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: const Text("Request Form", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          backgroundColor: Colors.red[900],
          centerTitle: true,
        ),
        drawer: SideDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formkey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Patient Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    _buildTextField('Patient Name', 'e.g. Mohammad Aliar', (value) => patient = value),
                    const SizedBox(height: 15),
                    _buildPhoneField(),
                    _buildTextField('Hospital Name', 'e.g Lahore Children Hospital', (value) => hospital = value),
                    const SizedBox(height: 15),
                    _buildLocationField(),
                    const SizedBox(height: 15),
                    _buildDropdown('Case', list, (value) => donationCase = value!),
                    const SizedBox(height: 15),
                    _buildTextField('Quantity of blood needed (pints)', 'e.g 15', (value) => bags = int.tryParse(value) ?? 0, keyboardType: TextInputType.number),
                    const SizedBox(height: 15),
                    _buildTextField('Details', 'e.g I have been suffering a lot so kindly give me the blood.', (value) => details = value),
                    const SizedBox(height: 20),
                    _buildBloodGroupChips(),
                    const SizedBox(height: 20),
                    _buildGenderChips(),
                    const SizedBox(height: 30),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged, {TextEditingController? controller, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isEmpty) return newValue;
              return newValue.copyWith(
                text: newValue.text.substring(0, 1).toUpperCase() + newValue.text.substring(1),
                selection: TextSelection.collapsed(offset: newValue.text.length),
              );
            }),
          ],
          decoration: InputDecoration(
            hintText: hint,
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
            errorBorder: _buildBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        IntlPhoneField(
          decoration: InputDecoration(
            hintText: '3221040476',
            border: _buildBorder(),
            focusedBorder: _buildBorder(),
            enabledBorder: _buildBorder(),
          ),
          initialCountryCode: 'PK',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (phone) {
            contact = phone.completeNumber;
          },
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Residence', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _locationController,
          onChanged: (value) {
            residence = value;
          },
          decoration: InputDecoration(
            hintText: 'e.g. House 131, Street 2, Gulberg Sukh Chayn Gardens, Lahore',
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
            errorBorder: _buildBorder(),
            suffixIcon: IconButton(
              icon: isLoadingLocation
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 2,
                ),
              )
                  : Icon(Icons.my_location, color: Colors.red[900]),
              onPressed: () async {
                setState(() {
                  isLoadingLocation = true; // Start loading
                });

                await _getCurrentPosition(); // Fetch location

                if (_currentAddress.isNotEmpty) {
                  setState(() {
                    _locationController.text = _currentAddress;
                    residence = _currentAddress;
                  });
                }

                setState(() {
                  isLoadingLocation = false; // Stop loading
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildBloodGroupChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Blood Group', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20.0,
          runSpacing: 10.0,
          children: List<Widget>.generate(groups.length, (int index) {
            return ChoiceChip(
              label: groups[index],
              selected: _selectedGroups[index],
              onSelected: (bool selected) {
                setState(() {
                  for (int i = 0; i < _selectedGroups.length; i++) {
                    _selectedGroups[i] = false;
                  }
                  _selectedGroups[index] = selected;
                  bloodGroup = selected ? (groups[index] as Text).data! : '';
                });
              },
              side: BorderSide(color: Colors.red[900]!, width: 3.0),
              selectedColor: Colors.red[900],
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w900,
                color: _selectedGroups[index] ? Colors.white : Colors.red[900],
              ),
              visualDensity: VisualDensity.compact, // Reduces unnecessary padding
            );
          }),
        ),
      ],
    );
  }

  Widget _buildGenderChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 13.0,
          runSpacing: 13.0,
          children: List<Widget>.generate(genders.length, (int index) {
            return ChoiceChip(
              label: genders[index],
              selected: _selectedGenders[index],
              onSelected: (bool selected) {
                setState(() {
                  for (int i = 0; i < _selectedGenders.length; i++) {
                    _selectedGenders[i] = false;
                  }
                  _selectedGenders[index] = selected;
                  gender = selected ? (index == 0 ? 'Male' : 'Female') : '';
                });
              },
              side: BorderSide(color: Colors.red[900]!, width: 3.0),
              selectedColor: Colors.red[900],
              backgroundColor: Colors.white,
              visualDensity: VisualDensity.compact, // Reduces unnecessary padding
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () async {
          if (donationCase != "None") {
            try {
              setState(() {
                isLoading = true;
              });
              notificationCount+=1;
              await _firebaseDatabase.addRequest(
                patient.trim(),
                contact,
                hospital.trim(),
                residence.trim(),
                donationCase.trim(),
                bags,
                bloodGroup.trim(),
                gender.trim(),
                details.trim(),
              );
              Get.snackbar('Success', 'Request added successfully!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(15),
                  icon: const Icon(Icons.check, color: Colors.white));
              setState(() {
                isLoading = false;
              });
            } catch (e) {
              setState(() {
                isLoading = false;
              });

              Get.snackbar(
                'Warning:',
                e.toString(),
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: const EdgeInsets.all(15),
                icon: const Icon(
                  Icons.message,
                  color: Colors.white,
                ),
              );
            }
          } else {
            print("ERROR: Case of donation not selected!");
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[900],
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          'Submit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[900]!, width: 3),
      borderRadius: BorderRadius.circular(10),
    );
  }
}