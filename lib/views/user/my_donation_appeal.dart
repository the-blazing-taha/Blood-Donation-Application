import 'package:blood/models/donations.dart';
import 'package:blood/views/admin/dashboard.dart';
import 'package:blood/views/user/donor_details.dart';
import 'package:blood/views/user/donors_list.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/databaseController.dart';
import 'my_requests.dart';

class DonationAppeal extends StatefulWidget {
  const DonationAppeal({super.key});

  @override
  State<DonationAppeal> createState() => _HomeState();
}

class _HomeState extends State<DonationAppeal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _donationsNumberController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  static List<String> bloodTypes = <String>['None','A+', 'B+', 'AB+', 'O+','A-', 'B-', 'AB-', 'O-'];
  static List<String> genders = <String>['None','Male','Female'];
  String bloodGroup='';
  String gender='' ;

  String hospital='';
  String patient='';
  String residence='';
  int numberOfDonations=-1;
  String contact='';
  String details='';

  void updateButton(int id) {
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
                    setState(() {
                      patient=value;
                    });
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: "Patient Name"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      residence=value;
                    });
                  },
                  controller: _locationController,
                  decoration: const InputDecoration(hintText: "Location"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                    setState(() {
                      numberOfDonations = int.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                    });
                  },
                  controller: _donationsNumberController,
                  decoration: const InputDecoration(hintText: "No of donations done:"),
                ),

                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      hospital=value;
                    });
                  },
                  controller: _hospitalController,
                  decoration: const InputDecoration(hintText: "Hospital"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      details=value;
                    });
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
                    setState(() {
                      bloodGroup=value!;
                    });
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
                    setState(() {

                    });
                  },
                  dropdownMenuEntries: genders.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if(patient!=''){
                    _databaseService.updateDonationAppeal(id: id, name: patient);
                    Navigator.of(context).pop();
                  }
                  if(bloodGroup!=''){
                    _databaseService.updateDonationAppeal(id: id, bloodGroup: bloodGroup);
                    Navigator.of(context).pop();
                  }
                  if(gender!=''){
                    _databaseService.updateDonationAppeal(id: id, gender: gender);
                    Navigator.of(context).pop();
                  }
                  if(residence!=''){
                    _databaseService.updateDonationAppeal(id: id, residence: residence);
                    Navigator.of(context).pop();
                  }
                  if(contact!=''){
                    _databaseService.updateDonationAppeal(id: id, contact: contact);
                    Navigator.of(context).pop();
                  }
                  if(numberOfDonations!=-1){
                    _databaseService.updateDonationAppeal(id: id, donationsDone: numberOfDonations);
                    Navigator.of(context).pop();
                  }
                  if(details!=''){
                    _databaseService.updateDonationAppeal(id: id, details: details);
                    Navigator.of(context).pop();
                  }
                  _genderController.clear();
                  _nameController.clear();
                  _bloodGroupController.clear();
                  _locationController.clear();
                  _detailsController.clear();
                  _genderController.clear();
                  _donationsNumberController.clear();
                  _hospitalController.clear();
                  setState(() {

                  });
                },
                child: const Text('Update Donation Appeal'),
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
    final DatabaseService databaseService = DatabaseService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Donation Appeal",
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
                      builder: (context) => const DonationAppeal(),
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
                selected: _selectedIndex == 6,
                onTap: () {
                  _onItemTapped(6);
                  Navigator.pop(context);
                  _authController.signout();
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings_sharp,
                  color: Colors.white,
                ),
                title: const Text('Admin',
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
                      builder: (context) => const Dashboard(),
                    ),
                  );
                },
              ),


              // Other ListTiles...
            ],
          ),
        ),
      ),



      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by name or location",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const Text(
            'Your Donation Appeal',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(
            child: FutureBuilder<List<Donation>>(
              future: databaseService.getDonation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Donation donation = snapshot.data![index];
                    return Center(
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    donation.bloodGroup,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              title: Text(
                                donation.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
                              ),
                              leading: const CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  Icons.person,
                                  size: 20,
                                ),
                              ),
                              trailing: Text(
                                "${donation.donationsDone} Donations Done",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.location_on_rounded),
                                  const SizedBox(width: 4),
                                  Text(donation.residence),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    disabledBackgroundColor:Colors.white,
                                  ),
                                  onPressed: () {
                                    updateButton(donation.id);
                                    setState(() {

                                    });
                                  },
                                  child: Text('Update', style: TextStyle(color: Colors.red[900])),
                                ),
                                const SizedBox(height: 4,),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    disabledBackgroundColor:Colors.white,
                                  ),
                                  onPressed: () {
                                    databaseService.deleteDonation(donation.id);
                                    setState(() {});
                                  },
                                  child: Text('Delete', style: TextStyle(color: Colors.red[900])),
                                ),
                                const SizedBox(height: 6,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[900],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DonorDetails(
                                          patient: donation.name,
                                          contact: donation.contact,
                                          hospital: donation.hospital,
                                          residence: donation.residence,
                                          bloodGroup: donation.bloodGroup,
                                          gender: donation.gender,
                                          noOfDonations: donation.donationsDone,
                                          details: donation.details,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Details',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
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
    );
  }
}
