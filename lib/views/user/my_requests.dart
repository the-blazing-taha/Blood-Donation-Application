import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/fireStoreDatabaseController.dart';
import 'details.dart';
import 'home.dart';
import 'my_donation_appeal.dart';
import 'package:timeago/timeago.dart' as timeago;




class Requests extends StatefulWidget {

  const Requests({super.key});
  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final fireStoreDatabaseController firebaseDatabase = fireStoreDatabaseController();
  final AuthController authController = AuthController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bagsController = TextEditingController();
  final TextEditingController _caseController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  static List<String> bloodTypes = <String>['None','A+', 'B+', 'AB+', 'O+','A-', 'B-', 'AB-', 'O-'];
  static List<String> donationCases = <String>['None','Anemia','Hemophilia','Thalassemia','Operation','Accident'];
  static List<String> genders = <String>['None','Male','Female'];
   String bloodGroup='';
   String gender='' ;
   int bags=-1;
   String hospital='';
   String patient='';
   String residence='';
   String donationCase='';
   String contact='';
   String details='';

  void updateButton(String id) {
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Update Request'),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value){
                      patient=value;
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: "Patient Name"),
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
                      bags = int.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                  },
                  controller: _bagsController,
                  decoration: const InputDecoration(hintText: "Bags"),
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
                  initialSelection: bloodTypes.first,
                  onSelected: (String? value) {
                      bloodGroup=value!;
                  },
                  dropdownMenuEntries: bloodTypes.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),
                DropdownMenu<String>(
                  hintText: "Donation Case",
                  controller: _caseController,
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
                  initialSelection: donationCases.first,
                  onSelected: (String? value) {
                      donationCase=value!;
                  },
                  dropdownMenuEntries: donationCases.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),
                DropdownMenu<String>(
                  hintText: "Gender",
                  controller: _genderController,
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
                  initialSelection: genders.first,
                  onSelected: (String? value) {
                        gender=value!;
                  },
                  dropdownMenuEntries: genders.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  try {
                    if (patient != '') {
                      firebaseDatabase.updateRequest(docId: id, name: patient);
                      Navigator.of(context).pop();
                    }
                    if (bloodGroup != '') {
                      firebaseDatabase.updateRequest(
                          docId: id, bloodGroup: bloodGroup);
                      Navigator.of(context).pop();
                    }
                    if (gender != '') {
                      firebaseDatabase.updateRequest(docId: id, gender: gender);
                      Navigator.of(context).pop();
                    }
                    if (residence != '') {
                      firebaseDatabase.updateRequest(
                          docId: id, residence: residence);
                      Navigator.of(context).pop();
                    }
                    if (contact != '') {
                      firebaseDatabase.updateRequest(
                          docId: id, contact: contact);
                      Navigator.of(context).pop();
                    }
                    if (donationCase != '') {
                      firebaseDatabase.updateRequest(
                          docId: id, case_: donationCase);
                      Navigator.of(context).pop();
                    }
                    if (details != '') {
                      firebaseDatabase.updateRequest(
                          docId: id, details: details);
                      Navigator.of(context).pop();
                    }
                    setState(() {
                      // updateButton(id);
                      _genderController.clear();
                      _nameController.clear();
                      _bloodGroupController.clear();
                      _locationController.clear();
                      _detailsController.clear();
                      _bagsController.clear();
                      _genderController.clear();
                      _caseController.clear();
                      _hospitalController.clear();
                    });
                    Get.snackbar("Success: ","Request updated successfully!",
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
                  }catch(e){
                    Get.snackbar("Failed: ",e.toString(),
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

                child: const Text('Update Request'),
              ),
              TextButton(
                onPressed: () {
                  _genderController.clear();
                  _nameController.clear();
                  _bloodGroupController.clear();
                  _locationController.clear();
                  _detailsController.clear();
                  _bagsController.clear();
                  _genderController.clear();
                  _caseController.clear();
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
    final Stream<QuerySnapshot> requestsCollection = FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .snapshots();
    int selectedIndex = 0;

    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Requests",
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
                  Icons.format_align_center,
                  color: Colors.white,
                ),
                title: const Text('My Donation Appeal',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: selectedIndex == 4,
                onTap: () {
                  onItemTapped(3);
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
                selected: selectedIndex == 5,
                onTap: () {
                  onItemTapped(5);
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
                selected: selectedIndex == 6,
                onTap: () {
                  onItemTapped(6);
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
                selected: selectedIndex == 7,
                onTap: () {
                  onItemTapped(7);
                  Navigator.pop(context);
                  authController.signout();
                },
              ),
              // Other ListTiles...
            ],
          ),
        ),
      ),



      body: Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: requestsCollection,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No requests found.'));
            }
            final requests = snapshot.data!.docs;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var createdAt = (requests[index]['createdAt'] as Timestamp).toDate();
                var timeAgo = timeago.format(createdAt);
                final request = requests[index];
                final data = request.data() as Map<String, dynamic>;

                return Center(
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            timeAgo,
                            style: const TextStyle(
                              fontSize: 18, // Adjusted for better fit
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          // Blood Group Badge
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
                                  fontSize: 18, // Adjusted for better fit
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5), // Spacing

                          // Main ListTile
                          ListTile(
                            contentPadding: EdgeInsets.zero, // Removes default padding
                            leading: const CircleAvatar(
                              radius: 25, // Bigger size for better visuals
                              child: Icon(Icons.person, size: 24),
                            ),
                            title: Text(
                              data['name'] ?? 'Unknown',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                                  "${data['bags'] ?? 'N/A'} Bags | ${data['case'] ?? 'N/A'}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Buttons Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
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
                                  // databaseService.deleteRequest(request.id);
                                  try {
                                    firebaseDatabase.deleteRequest(
                                        data['docId']);
                                    setState(() {});
                                    Get.snackbar("Success: ","Request deleted successfully!",
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
                                      builder: (context) => Details(
                                        patient: data['name'],
                                        contact: data['contact'],
                                        hospital: data['hospital'],
                                        residence: data['residence'],
                                        case_: data['case'],
                                        bags: data['bags'],
                                        bloodGroup: data['bloodGroup'],
                                        gender: data['gender'],
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
    );
  }
}


