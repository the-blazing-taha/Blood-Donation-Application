import 'dart:math';

import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/fireStoreDatabaseController.dart';
import 'details.dart';
import 'donor_details.dart';
import 'home.dart';
import 'my_donation_appeal.dart';
import 'my_requests.dart';


class NearbyDonors extends StatefulWidget {
  const NearbyDonors({super.key});

  @override
  State<NearbyDonors> createState() => _NearbyDonorsState();
}

class _NearbyDonorsState extends State<NearbyDonors> {
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fireStoreDatabaseController firebaseDatabase = fireStoreDatabaseController();
  Position? currentPosition;
  List<Map<String, dynamic>> nearbyRequesters = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void startLocationTracking() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });

    await firebaseDatabase.updateDonorPosition(position.longitude, position.latitude);
    findNearbyDonors();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

  void findNearbyDonors() async {
    if (currentPosition == null) return;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    double lat = currentPosition!.latitude;
    double lon = currentPosition!.longitude;

    QuerySnapshot snapshot = await firestore.collection('requests').get();
    List<Map<String, dynamic>> usersNearby = [];

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      double userLat = data['latitude'];
      double userLon = data['longitude'];
      double distance = calculateDistance(lat, lon, userLat, userLon);
      if (distance <= 0.1) { // 100 meters
        usersNearby.add(data);
      }
    }

    setState(() {
      nearbyRequesters = usersNearby;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Requesters", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                  Icons.format_align_center,
                  color: Colors.white,
                ),
                title: const Text('My Donation Appeal',
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
                      builder: (context) => const Profile(),
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
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text('Log Out',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: _selectedIndex == 8,
                onTap: () {
                  _onItemTapped(8);
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
          Center(
            child: currentPosition == null
                ? const Text("Press the button to find nearby requesters")
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Latitude: ${currentPosition?.latitude}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Longitude: ${currentPosition?.longitude}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: startLocationTracking,
            child: const Text("Find Nearby Requesters"),
          ),
          const Text("Requesters Near You", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: nearbyRequesters.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Add margin
                  elevation: 4, // Add shadow for better appearance
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0), // Add padding for spacing
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text properly
                      children: <Widget>[
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
                              nearbyRequesters[index]['bloodGroup'] ?? 'N/A',
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
                          leading: const CircleAvatar(
                            radius: 25, // Increased size for better visuals
                            child: Icon(Icons.person, size: 24),
                          ),
                          title: Text(
                            nearbyRequesters[index]['name'] ?? 'Unknown',
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
                                      nearbyRequesters[index]['residence'] ?? 'Unknown',
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${nearbyRequesters[index]['gender'] ?? 'N/A'} | ${nearbyRequesters[index]['case'] ?? '0'}",
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
                                      patient: nearbyRequesters[index]['name'],
                                      contact: nearbyRequesters[index]['contact'],
                                      hospital: nearbyRequesters[index]['hospital'],
                                      residence: nearbyRequesters[index]['residence'],
                                      case_: nearbyRequesters[index]['case'],
                                      bags: nearbyRequesters[index]['bags'],
                                      bloodGroup: nearbyRequesters[index]['bloodGroup'],
                                      gender: nearbyRequesters[index]['gender'],
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
