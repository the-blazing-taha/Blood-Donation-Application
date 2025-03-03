import 'package:blood/models/donations.dart';
import 'package:blood/views/user/donor_details.dart';
import 'package:flutter/material.dart';

import '../../controllers/databaseController.dart';
import 'dashboard.dart';
import 'inventory.dart';

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

    int selectedIndex = 0;

    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
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
                Scaffold.of(context)
                    .openDrawer(); // This will now work correctly
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
                  'Drawer Header',
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
                  'Dashboard',
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
                      builder: (context) => const Dashboard(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.inventory_2_sharp,
                  color: Colors.white,
                ),
                title: const Text(
                  'Inventory',
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
                      builder: (context) => const Inventory(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: databaseService.getDonation(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Donation donation = snapshot.data![index];
                return Center(
                    child: Card(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Keep this to minimize height
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red[900],
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                5.0), // Keep this padding small
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
                        title: Text(donation.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        leading: const CircleAvatar(
                          radius: 20,
                          child: Icon(
                            Icons.person,
                            size: 20,
                          ),
                        ),
                        trailing: Text(
                          "${donation.donationsDone} Donations done",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(
                                Icons.location_on_rounded), // Location icon
                            const SizedBox(
                                width:
                                    4), // Space between the icon and the text
                            Text(donation.residence), // Subtitle text
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              disabledBackgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              databaseService.deleteDonation(donation.id);
                              setState(() {});
                            },
                            child: Text('Delete',
                                style: TextStyle(color: Colors.red[900])),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
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
                                    residence: donation.residence,
                                    bloodGroup: donation.bloodGroup,
                                    gender: donation.gender,
                                    noOfDonations: donation.donationsDone,
                                    details: donation.details,
                                    weight: null,
                                    age: null,
                                    lastDonated: null,
                                    donationFrequency: null,
                                    highestEducation: null,
                                    currentOccupation: null,
                                    currentLivingArrg: null,
                                    eligibilityTest: null,
                                    futureDonationWillingness: null, email: null,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Details',
                                style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(
                              width:
                                  8), // Keep this small or remove if not needed
                        ],
                      ),
                    ],
                  ),
                ));
              });
        },
      ),
    );
  }
}
