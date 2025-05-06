import 'package:blood/views/user/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blood/views/user/donor_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/fireStoreDatabaseController.dart';
import 'drawer.dart';

class DonationAppeal extends StatefulWidget {
  const DonationAppeal({super.key});

  @override
  State<DonationAppeal> createState() => _HomeState();
}

class _HomeState extends State<DonationAppeal> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
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
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
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
  TextEditingController _lastDateController = TextEditingController();
  TextEditingController _firstDateController = TextEditingController();
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
  String firstDonated = '';

  int age = -1;
  String futureDonationWill = '';
  bool isOtherSelected = false;
  TextEditingController otherOccupationController = TextEditingController();
  int weight = -1;

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
        _lastDateController.text = "${picked.year}-${picked.month}-${picked.day}";
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
        _firstDateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }
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
                const SizedBox(height: 4,), DropdownMenu<String>(
                  hintText: "Blood Group",
                  controller: _bloodGroupController,
                  inputDecorationTheme: InputDecorationTheme(
                    border:const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 3,),
                        borderRadius:BorderRadius.all(Radius.circular(10.0))
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
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 3,),
                        borderRadius:BorderRadius.all(Radius.circular(10.0))
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
                    border:const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 3,),
                        borderRadius:BorderRadius.all(Radius.circular(10.0))
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
                  disableLengthCheck: false, // Prevents default length restriction
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
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 3,),
                        borderRadius:BorderRadius.all(Radius.circular(10.0))
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

                _buildDateField(),
                _buildDateField2(),
                DropdownMenu<String>(
                  hintText: "Current Occupation",
                  inputDecorationTheme: InputDecorationTheme(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 3,),
                        borderRadius:BorderRadius.all(Radius.circular(10.0))
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
                    border:const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 3,),
                        borderRadius:BorderRadius.all(Radius.circular(10.0))
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
                  String lastDonation = _selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : '';
                  String firstDonation = _selectedDate2 != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate2!)
                      : '';

                  try {
                    if (_selectedDate==null || _selectedDate2==null || _selectedDate!.isAfter(_selectedDate2!) || _selectedDate==_selectedDate2) {
                      if (donor != '') {
                        _firebaseDatabase.updateDonationAppeal(
                            docId: id, name: donor.trim());
                      }
                      if (bloodGroup != '') {
                        _firebaseDatabase.updateDonationAppeal(
                            docId: id, bloodGroup: bloodGroup.trim());
                      }
                      if (lastDonation != '') {
                        _firebaseDatabase.updateDonationAppeal(
                            docId: id, lastDonation: lastDonation.trim());
                      }
                      if (firstDonation != '') {
                        _firebaseDatabase.updateDonationAppeal(
                            docId: id, firstDonation: firstDonation.trim());
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
                            docId: id,
                            currentOccupation: currentOccupation.trim());
                      }
                      if (donationFrequency != '') {
                        _firebaseDatabase.updateDonationAppeal(
                            docId: id,
                            donationFrequency: donationFrequency.trim());
                      }
                      if (highestEducation != '') {
                        _firebaseDatabase.updateDonationAppeal(
                            docId: id,
                            highestEducation: highestEducation.trim());
                      }
                      if (age != -1) {
                        _firebaseDatabase.updateDonationAppeal(
                            docId: id, age: age);
                      }
                      if (futureDonationWill != '') {
                        _firebaseDatabase.updateDonationAppeal(
                            docId: id,
                            futureDonationWillingness: futureDonationWill);
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
                      _lastDateController.clear();
                      _firstDateController.clear();
                      Navigator.of(context).pop();
                      Get.snackbar("Success: ",
                          "Donor registration updated successfully!",
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
                    else{
                      Get.snackbar("ERROR: ",
                          "First Donation date should be before Last Donation date!",
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
                  _lastDateController.clear();
                  _firstDateController.clear();
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
        drawer: SideDrawer(),

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
                                        // Show confirmation dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              backgroundColor: Colors.white,
                                              title: Text(
                                                'Confirm Deletion',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.red[900],
                                                ),
                                              ),
                                              content: Text(
                                                'Are you sure you want to delete this donation?',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    // If user presses "No", close the dialog
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                      color: Colors.red[900],
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.white, backgroundColor: Colors.red[900], // White text color
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    // If user presses "Yes", delete the donation and show snackbar
                                                    try {
                                                      firebaseDatabase.deleteDonation(data['docId']);
                                                      setState(() {
                                                        donorMode = false;
                                                      });
                                                      Navigator.of(context).pop(); // Close the dialog
                                                      Get.snackbar(
                                                        "Success:",
                                                        "Donation deleted successfully!",
                                                        backgroundColor: Colors.red,
                                                        colorText: Colors.white,
                                                        margin: const EdgeInsets.all(15),
                                                        snackPosition: SnackPosition.BOTTOM,
                                                        icon: const Icon(
                                                          Icons.check_circle,
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                      Get.snackbar(
                                                        "Error:",
                                                        e.toString(),
                                                        backgroundColor: Colors.red,
                                                        colorText: Colors.white,
                                                        margin: const EdgeInsets.all(15),
                                                        snackPosition: SnackPosition.BOTTOM,
                                                        icon: const Icon(
                                                          Icons.error,
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
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
                                              firstDonated: data['firstDonated'],
                                              lastDonated: data['lastDonated'],
                                              donationFrequency: data['donationFrequency'],
                                              highestEducation: data['highestEducation'],
                                              currentOccupation: data['currentOccupation'],
                                              currentLivingArrg: data['currentLivingArrg'],
                                              eligibilityTest: data['eligibilityTest'],
                                              futureDonationWillingness: data['futureDonationWillingness'],
                                              email: data['email'],
                                              profileImage: data['profileUrl'],
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

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _lastDateController,
          decoration: InputDecoration(
            labelText: "Last Donated",
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
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
        TextFormField(
          controller: _firstDateController,
          decoration: InputDecoration(
            labelText: "First Donated",
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
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
  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide( width: 0),
      borderRadius: BorderRadius.circular(10),
    );
  }

}


