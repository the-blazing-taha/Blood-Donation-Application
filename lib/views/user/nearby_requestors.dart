import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/auth_controller.dart';
import '../../controllers/fireStoreDatabaseController.dart';
import 'details.dart';


class NearbyRequesters extends StatefulWidget {
  const NearbyRequesters({super.key});

  @override
  State<NearbyRequesters> createState() => _NearbyRequestersState();
}

class _NearbyRequestersState extends State<NearbyRequesters> {
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fireStoreDatabaseController firebaseDatabase = fireStoreDatabaseController();

  Position? currentPosition;
  List<Map<String, dynamic>> nearbyRequesters = [];
  bool isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> startLocationTracking() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
        isLoading = true;
      });

      if (await doesUserExist()) {
        await firebaseDatabase.updateRequesterPosition(position.longitude, position.latitude);
      }

      await findNearbyRequesters();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<bool> doesUserExist() async {
    final doc = await FirebaseFirestore.instance.collection('requests').doc(auth.currentUser?.uid).get();
    return doc.exists;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

  Future<void> findNearbyRequesters() async {
    if (currentPosition == null) return;

    setState(() {
      isLoading = true; // Start loading
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    double lat = currentPosition!.latitude;
    double lon = currentPosition!.longitude;
    double searchRadiusKm = 0.1; // 100 meters

    double latChange = searchRadiusKm / 111.12;
    double lonChange = searchRadiusKm / (111.12 * cos(lat * pi / 180));

    try {
      QuerySnapshot snapshot = await firestore.collection('requests')
          .where('latitude', isGreaterThan: lat - latChange)
          .where('latitude', isLessThan: lat + latChange)
          .where('longitude', isGreaterThan: lon - lonChange)
          .where('longitude', isLessThan: lon + lonChange)
          .where('userId', isNotEqualTo: auth.currentUser!.uid)
          .get();

      List<Map<String, dynamic>> usersNearby = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['latitude'] == null || data['longitude'] == null) continue;

        double userLat = data['latitude'];
        double userLon = data['longitude'];
        double distance = calculateDistance(lat, lon, userLat, userLon);

        if (distance <= 0.1) { // 100 meters
          usersNearby.add(data);
        }
      }

      setState(() {
        nearbyRequesters = usersNearby;
        isLoading = false; // Stop loading
      });
    } catch (e) {
      print("Error finding requesters: $e");
      setState(() {
        isLoading = false; // Stop loading even if error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Requesters", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.red[900],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: currentPosition == null
                ? const Text("Press the button to find nearby requesters")
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Latitude: ${currentPosition?.latitude}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Longitude: ${currentPosition?.longitude}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: isLoading ? null : startLocationTracking, // Disable button when loading
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[900],
            ),
            child: isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2, // Make spinner smaller
              ),
            )
                : const Text("Find Nearby Requesters",style: TextStyle(color: Colors.white),),
          ),

          const SizedBox(height: 10),
          const Text("Requesters Near You", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Expanded(
            child: nearbyRequesters.isEmpty
                ? const Center(child: Text("No nearby Requesters found"))
                : ListView.builder(
              itemCount: nearbyRequesters.length,
              itemBuilder: (context, index) {
                var request = nearbyRequesters[index];
                var createdAt = request['createdAt'] != null
                    ? (request['createdAt'] as Timestamp).toDate()
                    : DateTime.now();
                var timeAgo = timeago.format(createdAt);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: const CircleAvatar(radius: 25, child: Icon(Icons.person, size: 24)),
                    title: Text(request['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text("${request['bloodGroup'] ?? 'N/A'} | $timeAgo"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                              bloodGroup: nearbyRequesters[index]['bloodGroup'],
                              gender: nearbyRequesters[index]['gender'],
                              case_:nearbyRequesters[index]['case'],
                              bags: nearbyRequesters[index]['bags']
                            ),
                          ),
                        );
                      },
                      child: const Text('Details', style: TextStyle(color: Colors.white)),
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
