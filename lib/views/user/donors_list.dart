import 'package:blood/models/donations.dart';
import 'package:blood/views/user/donor_details.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:flutter/material.dart';

import '../../controllers/databaseController.dart';
import 'home.dart';
import 'my_requests.dart';

class DonorList extends StatefulWidget {
  const DonorList({super.key});


  @override
  State<DonorList> createState() => _DonorListState();
}

class _DonorListState extends State<DonorList> {


  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";


  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

    // Filter the list based on search query

    SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
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
          // List of donors
        ],
      ),
    );


    int _selectedIndex = 0;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "All Donors Available",
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



      body: FutureBuilder(
        future: databaseService.getDonation(),
        builder:  (context,snapshot){
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Donation donation = snapshot.data![index];
                return Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Keep this to minimize height
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[900],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(5.0), // Keep this padding small
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
                            title: Text(donation.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            leading: const CircleAvatar(
                              radius: 20,
                              child: Icon(
                                Icons.person,
                                size: 20,
                              ),
                            ),
                            trailing: Text("${donation.donationsDone} Donations done" ,style:  const TextStyle(color: Colors.grey,fontSize: 15),),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.location_on_rounded), // Location icon
                                const SizedBox(width: 4), // Space between the icon and the text
                                Text(donation.residence), // Subtitle text
                              ],

                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
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
                                child: const Text('Details', style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 8), // Keep this small or remove if not needed
                            ],
                          ),
                        ],
                      ),
                    )
                );
              });},
      ),
    );
  }
}