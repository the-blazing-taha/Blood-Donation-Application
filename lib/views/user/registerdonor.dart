import 'dart:core';
import 'package:blood/views/user/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/fireStoreDatabaseController.dart';
import 'drawer.dart';
import 'package:intl/intl.dart';

class RequestDonor extends StatefulWidget {
  const RequestDonor({super.key});

  @override
  State<RequestDonor> createState() => _RequestDonorState();
}

class _RequestDonorState extends State<RequestDonor> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late String name;
  late String? residence = null;
  late String? contact = null;
  late int noOfDonation;
  late String bloodGroup;
  late String gender;
  late String? details = null;
  late int weight;
  late int age;
  late String donationFrequency;
  late String highestEducation;
  late String? currentOccupation;
  late String currentLivingArrg;
  late String eligibilityTest;
  late String futureDonationWillingness;

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

  static const List<String> donation_frequency = <String>[
    'None',
    'Once every 3 months',
    'Once every 6 months',
    'Once a year',
    'Less than once a year'
  ];

  static const List<String> highest_education = <String>[
    'None',
    'Less than Matriculation',
    'Matriculation',
    'High School',
    'Bachelors Degree',
    'Masters Degree',
    'PhD'
  ];

  static const List<String> occupation = <String>[
    'Student',
    'Soldier',
    'Public functionary',
    'Medical staff',
    'Industrial',
    'Farmer',
    'Clerk',
    'Teacher',
    'Other'
  ];

  static const List<String> living_arrangement = <String>[
    'Registered Residence',
    'Non-registered Residence'
  ];

  static const List<String> bloodTest = <String>['Yes', 'No'];
  final FirebaseAuth auth = FirebaseAuth.instance;
  static const List<String> future_donation = <String>['Yes', 'No'];
  final TextEditingController _locationController = TextEditingController();

  bool isOtherSelected = false;
  TextEditingController otherOccupationController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  DateTime? _selectedDate;
  DateTime? _selectedDate2;

  final fireStoreDatabaseController _firebaseDatabase = fireStoreDatabaseController();
  final AuthController authController = AuthController();

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('Location services are disabled. Please enable them.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
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
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return await _getAddressFromLatLng(position);
    } catch (e) {
      debugPrint("Error fetching location: $e");
      return null;
    }
  }

  Future<String?> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      return '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    } catch (e) {
      debugPrint("Error fetching address: $e");
      return null;
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate2 = picked;
        _dateController2.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register as donor", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                    const Text('Donor Form', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 10),
                    _buildTextField('Donor Name', 'e.g. Mohammad Aliar', (value) => name = value),
                    const SizedBox(height: 15),
                    _buildPhoneField(),
                    _buildLocationField(),
                    const SizedBox(height: 15),
                    _buildTextFieldDetails('Details (Optional)', 'Serving humanity is my passion', (value) => details = value),
                    const SizedBox(height: 15),
                    _buildTextField('Number of donations done:', 'e.g 5', (value) => noOfDonation = int.tryParse(value) ?? 0, keyboardType: TextInputType.number),
                    const SizedBox(height: 15),
                    _buildTextField('Your Weight (KG):', 'e.g 70', (value) => weight = int.tryParse(value) ?? 0, keyboardType: TextInputType.number),
                    const SizedBox(height: 15),
                    _buildTextField('Your age (Years):', 'e.g 22', (value) => age = int.tryParse(value) ?? 0, keyboardType: TextInputType.number),
                    const SizedBox(height: 15),
                    _buildDateField2(),
                    const SizedBox(height: 15),
                    _buildDateField(),
                    const SizedBox(height: 15),
                    _buildDropdown('Blood Donation Frequency:', donation_frequency, (value) => donationFrequency = value!),
                    const SizedBox(height: 15),
                    _buildDropdown('Highest level of education:', highest_education, (value) => highestEducation = value!),
                    const SizedBox(height: 15),
                    _buildDropdown('Current Occupation:', occupation, (value) {
                      currentOccupation = value;
                      isOtherSelected = value == 'Other';
                    }),
                    if (isOtherSelected) _buildTextField('Enter your occupation', '', (value) => currentOccupation = value, controller: otherOccupationController),
                    const SizedBox(height: 15),
                    _buildDropdown('Living Arrangement:', living_arrangement, (value) => currentLivingArrg = value!),
                    const SizedBox(height: 15),
                    _buildDropdown('Will you donate in future?', future_donation, (value) => futureDonationWillingness = value!),
                    const SizedBox(height: 15),
                    _buildDropdown('Have you passed a blood test for donation eligibility in the last 6 months?', bloodTest, (value) => eligibilityTest = value!),
                    const SizedBox(height: 20),
                    _buildBloodGroupChips(),
                    const SizedBox(height: 20),
                    _buildGenderChips(),
                    const SizedBox(height: 30),
                    _buildSubmitButton(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      Function(String) onChanged, {
        TextEditingController? controller,
        TextInputType keyboardType = TextInputType.text,
      }) {
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
            // Allow letters, spaces, and numbers
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

  Widget _buildTextFieldDetails(
      String label,
      String hint,
      Function(String) onChanged, {
        TextEditingController? controller,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.none, // Don't auto-capitalize every word
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isEmpty) return newValue;

              String text = newValue.text;
              String capitalized = text[0].toUpperCase() + text.substring(1);

              return newValue.copyWith(
                text: capitalized,
                selection: TextSelection.collapsed(offset: capitalized.length),
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
        const Text('Contact (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
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
        const Text('Residence (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _locationController,
          onChanged: (value) {
            residence = value;
          },
          decoration: InputDecoration(
            hintText: 'e.g House. 131, Street 2, Gulberg Sukh Chayn Gardens Lahore, District Kasur',
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
            errorBorder: _buildBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.my_location, color: Colors.red[900]),
              onPressed: () async {
                String? address = await _getCurrentPosition();
                if (address != null) {
                  _locationController.text = address;
                  residence = address;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Last Donated  (Leave it empty if you have not donated yet):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _dateController,
          decoration: InputDecoration(
            labelText: "Select Date",
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.red[900]),
              onPressed: () => _selectDate(context),
            ),
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
        ),
      ],
    );
  }

  Widget _buildDateField2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('First Donated (Leave it empty if you have not donated yet):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _dateController2,
          decoration: InputDecoration(
            labelText: "Select Date",
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.red[900]),
              onPressed: () => _selectDate2(context),
            ),
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
          ),
          readOnly: true,
          onTap: () => _selectDate2(context),
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
              showCheckmark: false, // Hides the tick mark
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
              showCheckmark: false, // Hides the tick mark
              label: genders[index],
              selected: _selectedGenders[index],
              onSelected: (bool selected) {
                setState(() {
                  for (int i = 0; i < _selectedGenders.length; i++) {
                    _selectedGenders[i] = false;
                  }
                  _selectedGenders[index] = selected;
                  gender = selected ? (index == 0 ? 'male' : 'female') : '';
                });
              },
              side: BorderSide(color: Colors.red[900]!, width: 3.0),
              selectedColor: Colors.red[900],
              backgroundColor: Colors.white,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      alignment: Alignment.center,
      child: StreamBuilder<bool>(
        stream: _firebaseDatabase.doesDonorExist(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          bool donorExists = snapshot.data ?? false;

          return ElevatedButton(
            onPressed: donorExists
                ? null
                : () async {
              try {
                if (_selectedDate==null && _selectedDate2==null || _selectedDate!.isAfter(_selectedDate2!) || _selectedDate==_selectedDate2) {
                  // Format the date before passing it
                  String formattedDate = _selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : '';
                  String formattedDate2 = _selectedDate2 != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate2!)
                      : '';
                  await _firebaseDatabase.addDonor(
                    name,
                    contact,
                    residence,
                    noOfDonation,
                    bloodGroup,
                    gender,
                    details,
                    weight,
                    age,
                    formattedDate,
                    formattedDate2,
                    donationFrequency,
                    highestEducation,
                    currentOccupation!,
                    currentLivingArrg,
                    eligibilityTest,
                    futureDonationWillingness,
                  );
                  setState(() {
                    donorMode = true;
                  });

                  Get.snackbar('Success', 'Donor added successfully!',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(15),
                      icon: const Icon(Icons.check, color: Colors.white));
                }
                else {
                  Get.snackbar('ERROR:',
                      'First Donation date should be before Last Donation date!',
                      backgroundColor: Colors.red[900],
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(15),
                      icon: const Icon(Icons.check, color: Colors.white));
                }
              } catch (e) {
                Get.snackbar('ERROR', e.toString(),
                    backgroundColor: Colors.red[900],
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(15),
                    icon: const Icon(Icons.error, color: Colors.white));
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: donorExists ? Colors.grey : Colors.red[900],
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
    );
  }
  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[900]!, width: 3),
      borderRadius: BorderRadius.circular(10),
    );
  }
}