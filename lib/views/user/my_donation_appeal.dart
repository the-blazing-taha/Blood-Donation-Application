import 'package:blood/views/user/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blood/views/user/donor_details.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/auth_controller.dart';
import '../../controllers/fireStoreDatabaseController.dart';
import 'home.dart';
import 'my_requests.dart';
import 'nearby_donors.dart';
import 'nearby_requestors.dart';

class DonationAppeal extends StatefulWidget {
  const DonationAppeal({super.key});

  @override
  State<DonationAppeal> createState() => _HomeState();
}

class _HomeState extends State<DonationAppeal> {
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _donationsNumberController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final fireStoreDatabaseController _firebaseDatabase = fireStoreDatabaseController();

  static List<String> bloodTypes = <String>['None','A+', 'B+', 'AB+', 'O+','A-', 'B-', 'AB-', 'O-'];
  static List<String> genders = <String>['None','Male','Female'];
  static List<String> last_donated = <String>[
    'None',
    'Within last month',
    'Within Last 3 months',
    'Within Last 6 months',
    'Last year'
  ];

  static List<String> donation_frequency = <String>[
    'None',
    'Once every 3 months',
    'Once every 6 months',
    'Once a year',
    'Less than once a year'
  ];

  static List<String> highest_education = <String>[
    'None',
    'Less than Matriculation',
    'Matriculation',
    'High School',
    'Bachelors Degree',
    'Masters Degree',
    'PhD'
  ];

  static List<String> ocupation = <String>[
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

  static List<String> living_arrangement = <String>[
    'Registered Residence',
    'Non-registered Residence'
  ];

  String bloodGroup='';
  String gender='' ;
  String hospital='';
  String donor='';
  String residence='';
  int numberOfDonations=-1;
  String contact='';
  String details='';

  String donationFrequency = '';
  String currentOccupation = '';
  String livingArrangement = '';
  String eligibilityTest = '';
  String highestEducation = '';
  String lastDonated = '';
  int age = -1;
  String futureDonationWill = '';
  bool isOtherSelected = false;
  TextEditingController otherOccupationController = TextEditingController();
  int weight = -1;


  void updateButton(String id) {
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Update Donation'),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value){
                      donor=value;
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: "Donor Name"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                      residence=value;
                  },
                  controller: _locationController,
                  decoration: const InputDecoration(hintText: "Location"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                      numberOfDonations = int.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                  },
                  controller: _donationsNumberController,
                  decoration: const InputDecoration(hintText: "No of donations done:"),
                ),

                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                      hospital=value;
                  },
                  controller: _hospitalController,
                  decoration: const InputDecoration(hintText: "Hospital"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                      details=value;
                  },
                  controller: _detailsController,
                  decoration: const InputDecoration(hintText: "Details"),
                ),
                const SizedBox(height: 4,),
                DropdownMenu<String>(
                  hintText: "Blood Group",
                  controller: _bloodGroupController,
                  inputDecorationTheme: InputDecorationTheme(
                    border: WidgetStateInputBorder.resolveWith(
                          (states) => states.contains(WidgetState.focused)
                          ?  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                          :  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 3,),
                          borderRadius:BorderRadius.all(Radius.circular(10.0))
                      ),

                    ),
                  ),
                  width: 325,
                  onSelected: (String? value) {
                      bloodGroup=value!;
                  },
                  dropdownMenuEntries: bloodTypes.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),
                DropdownMenu<String>(
                  hintText: "Gender",
                  controller: _genderController,
                  inputDecorationTheme: InputDecorationTheme(
                    border: WidgetStateInputBorder.resolveWith(
                          (states) => states.contains(WidgetState.focused)
                          ?  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                          :  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 3,),
                          borderRadius:BorderRadius.all(Radius.circular(10.0))
                      ),

                    ),
                  ),
                  width: 325,
                  onSelected: (String? value) {
                    setState(() {

                    });
                  },
                  dropdownMenuEntries: genders.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),

                DropdownMenu<String>(
                  hintText: "Highest Education",
                  inputDecorationTheme: InputDecorationTheme(
                    border: WidgetStateInputBorder.resolveWith(
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
                IntlPhoneField(
                  decoration: InputDecoration(
                    hintText: '3221040476',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[900]!),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[900]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[900]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  initialCountryCode: 'PK',
                  disableLengthCheck: true, // Prevents default length restriction
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits (0-9)
                  ],
                  onChanged: (phone) {
                      contact = phone.completeNumber;
                  },
                ),
                DropdownMenu<String>(
                  hintText: "Frequency of donation",
                  inputDecorationTheme: InputDecorationTheme(
                    border: WidgetStateInputBorder.resolveWith(
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
                      donationFrequency = value!;
                  },
                  dropdownMenuEntries: donation_frequency
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                DropdownMenu<String>(
                  hintText: "Last Donated",
                  inputDecorationTheme: InputDecorationTheme(
                    border: WidgetStateInputBorder.resolveWith(
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
                      lastDonated = value!;
                  },
                  dropdownMenuEntries: last_donated
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                DropdownMenu<String>(
                  hintText: "Current Occupation",
                  inputDecorationTheme: InputDecorationTheme(
                    border: WidgetStateInputBorder.resolveWith(
                          (states) => states.contains(WidgetState.focused)
                          ? const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))
                          : const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                  width: 325,
                  onSelected: (value) {
                      currentOccupation = value!;
                      isOtherSelected = value == 'Other';
                  },
                  dropdownMenuEntries: ocupation
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                if (isOtherSelected)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: otherOccupationController,
                      decoration: InputDecoration(
                        labelText: "Enter your occupation",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                          currentOccupation = value;
                      },
                    ),
                  ),
                DropdownMenu<String>(
                  hintText: "Current Living Arrangement",
                  inputDecorationTheme: InputDecorationTheme(
                    border: WidgetStateInputBorder.resolveWith(
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
                      livingArrangement = value!;
                  },
                  dropdownMenuEntries: living_arrangement
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  try {
                    if (donor != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, name: donor.trim());
                    }
                    if (bloodGroup != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, bloodGroup: bloodGroup.trim());
                    }
                    if (gender != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, gender: gender.trim());
                    }
                    if (residence != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, residence: residence.trim());
                    }
                    if (contact != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, contact: contact.trim());
                    }
                    if (numberOfDonations != -1) {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, donationsDone: numberOfDonations);
                    }
                    if (details != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, details: details.trim());
                    }
                    if (currentOccupation != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, currentOccupation: currentOccupation.trim());
                    }
                    if (donationFrequency != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, donationFrequency: donationFrequency.trim());
                    }
                    if (highestEducation != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, highestEducation: highestEducation.trim());
                    }
                    if (age != -1) {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, age: age);
                    }
                    if (futureDonationWill != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, futureDonationWillingness: futureDonationWill);
                    }
                    if (weight != -1) {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, weight: weight);
                    }
                    if (livingArrangement != '') {
                      _firebaseDatabase.updateDonationAppeal(
                          docId: id, currentLivingArrg: livingArrangement);
                    }

                      _nameController.clear();
                      _bloodGroupController.clear();
                      _locationController.clear();
                      _detailsController.clear();
                      _genderController.clear();
                      _donationsNumberController.clear();
                      _hospitalController.clear();
                    Navigator.of(context).pop();
                    Get.snackbar("Success: ", "Donor registration updated successfully!",
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
                  catch(e){
                    Get.snackbar("Error updating the donor registration: ", e.toString(),
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
                },
                child: const Text('Update Donor Registration'),
              ),
              TextButton(
                onPressed: () {
                  _genderController.clear();
                  _nameController.clear();
                  _bloodGroupController.clear();
                  _locationController.clear();
                  _detailsController.clear();
                  _genderController.clear();
                  _donationsNumberController.clear();
                  _hospitalController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> donorsCollection = FirebaseFirestore.instance
        .collection('donors')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .snapshots();
    final fireStoreDatabaseController firebaseDatabase = fireStoreDatabaseController();
    final user=FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).get();

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Donor Registration",
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
                  child: Column(
                    children: [
                      const Text(
                        'Life Sync',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: user,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show a loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}'); // Handle errors
                          } else if (snapshot.hasData && snapshot.data!.exists) {
                            Map<String, dynamic>? userData = snapshot.data!.data();
                            String? profileImageUrl = userData?['profileImage'];
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 30, // Adjust size as needed
                                  backgroundColor: Colors.grey[300], // Fallback color
                                  child: ClipOval(
                                    child: profileImageUrl != null && profileImageUrl.isNotEmpty
                                        ? Image.network(
                                      profileImageUrl,
                                      width: 60, // 2 * radius
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                        : const Icon(Icons.person, size: 40), // Display default icon if no image
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Text('No user data found.');
                          }
                        },
                      ),
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: user,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show a loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}'); // Handle errors
                          } else if (snapshot.hasData && snapshot.data!.exists) {
                            Map<String, dynamic>? userData = snapshot.data!.data();
                            String? userName = userData?['fullName'];
                            return Column(
                              children: [
                                Text(userName as String, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily:'Pacifico' ),),
                              ],
                            );
                          } else {
                            return const Text('No user data found.');
                          }
                        },
                      ),
                    ],
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
                    Icons.bloodtype_sharp,
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
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: const Text('Your Donation Registration',
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
                        builder: (context) => Profile(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.near_me,
                    color: Colors.white,
                  ),
                  title: const Text('Nearby donors',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  selected: _selectedIndex == 7,
                  onTap: () {
                    _onItemTapped(7);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NearbyDonors(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.near_me_outlined,
                    color: Colors.white,
                  ),
                  title: const Text('Nearby Requesters',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  selected: _selectedIndex == 8,
                  onTap: () {
                    _onItemTapped(8);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NearbyRequestors(),
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
                  selected: _selectedIndex == 9,
                  onTap: () {
                    _onItemTapped(9);
                    Navigator.pop(context);
                    _authController.signout();
                  },
                ),
                // Other ListTiles...
              ],
            ),
          ),
        ),

        body: Column(
          children: [
            const Text(
              'Your Donor Registration',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: donorsCollection,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No donations found.'));
                  }
                  final donors = snapshot.data!.docs;
                  return ListView.builder(

                    // scrollDirection: Axis.horizontal,
                    itemCount: donors.length,
                    itemBuilder: (context, index) {
                      final donor = donors[index];
                      final data = donor.data() as Map<String, dynamic>;
                      var createdAt = donor['createdAt'] != null
                          ? (donor['createdAt'] as Timestamp).toDate()
                          : DateTime.now();
                      var timeAgo = timeago.format(createdAt);
                      return Center(
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Add margin
                          elevation: 4, // Add shadow for better appearance
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0), // Add padding for spacing
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text properly
                              children: <Widget>[
                                Text(
                                  timeAgo,
                                  style: const TextStyle(
                                    fontSize: 18, // Adjusted for better fit
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                // Blood Group Tag
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red[900],
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data['bloodGroup'] ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 18, // Slightly smaller for better fit
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                // Main ListTile
                                ListTile(
                                  contentPadding: EdgeInsets.zero, // Remove default padding
                                  leading:  CircleAvatar(
                                    radius: 30, // Adjust size as needed
                                    backgroundColor: Colors.grey[300], // Fallback color
                                    child: ClipOval(
                                      child: data['profileUrl'] != null &&
                                          data['profileUrl'].isNotEmpty
                                          ? Image.network(
                                        data['profileUrl'],
                                        width: 100, // 2 * radius
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                          : const Icon(Icons.person,
                                          size: 40), // Display default icon if no image
                                    ),
                                  ),
                                  title: Text(
                                    data['name'] ?? 'Unknown',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    overflow: TextOverflow.ellipsis, // Prevents text overflow
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_rounded, size: 16),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              data['residence'] ?? 'Unknown',
                                              style: const TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${data['gender'] ?? 'N/A'} | ${data['donations_done'] ?? '0'} donations done",
                                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Button Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                          updateButton(data['docId']);
                                          setState(() {});
                                      },
                                      child: const Text('Update'),
                                    ),

                                    const SizedBox(width: 6),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        try {
                                          firebaseDatabase.deleteDonation(data['docId']);
                                          setState(() {donorMode=false;});
                                          Get.snackbar("Success: ","Donation deleted successfully!",
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
                                        catch(e){
                                          Get.snackbar("Error: ", e.toString(),
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
                                      },
                                      child: const Text('Delete'),
                                    ),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DonorDetails(
                                              patient: data['name'],
                                              contact: data['contact'],
                                              residence: data['residence'],
                                              bloodGroup: data['bloodGroup'],
                                              gender: data['gender'],
                                              noOfDonations: data['donations_done'],
                                              details: data['details'],
                                              weight: data['weight'],
                                              age: data['age'],
                                              lastDonated: data['lastDonated'],
                                              donationFrequency: data['donationFrequency'],
                                              highestEducation: data['highestEducation'],
                                              currentOccupation: data['currentOccupation'],
                                              currentLivingArrg: data['currentLivingArrg'],
                                              eligibilityTest: data['eligibilityTest'],
                                              futureDonationWillingness: data['futureDonationWillingness'],
                                              email: data['profileUrl'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Details', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


