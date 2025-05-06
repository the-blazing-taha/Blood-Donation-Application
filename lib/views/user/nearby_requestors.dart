import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/fireStoreDatabaseController.dart';
import 'chat_screen.dart';
import 'details.dart';

class NearbyRequestors extends StatefulWidget {
  const NearbyRequestors({super.key});
  static const route = '/nearby-donors';

  @override
  State<NearbyRequestors> createState() => _NearbyRequestorsState();
}

class _NearbyRequestorsState extends State<NearbyRequestors> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fireStoreDatabaseController firebaseDatabase =
  fireStoreDatabaseController();
  Position? currentPosition;
  List<Map<String, dynamic>> nearbyRequesters = [];
  bool isLoading = false;
  String selectedBloodGroup = '';
  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  final Map<String, List<String>> compatibleBloodGroups = {
    'A+': ['A+', 'AB+'],
    'A-': ['A-', 'AB-','A+','AB+'],
    'B+': ['B+', 'AB+'],
    'B-': ['B-', 'B+', 'AB+', 'AB-'],
    'O+': ['A+', 'B+', 'O+', 'AB+'],
    'O-': ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
    'AB+': ['AB+'],
    'AB-': ['AB+', 'AB-'],
  };

  Future<void> startLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        currentPosition = position;
        isLoading = true;
      });

      if (await doesUserExist()) {
        await firebaseDatabase.updateDonorPosition(
            position.longitude, position.latitude);
      }

      await findNearbyRequesters();
    } catch (e) {
      print("Error getting location: $e");
    }
  }


  Future<bool> doesUserExist() async {
    final doc = await FirebaseFirestore.instance
        .collection('requests')
        .doc(auth.currentUser?.uid)
        .get();
    return doc.exists;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

  Future<void> findNearbyRequesters() async {
    if (currentPosition == null || selectedBloodGroup.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    double lat = currentPosition!.latitude;
    double lon = currentPosition!.longitude;
    double searchRadiusKm = 15; // 100 meters
    double latChange = searchRadiusKm / 111.12;
    double lonChange = searchRadiusKm / (111.12 * cos(lat * pi / 180));

    try {
      List<String> validBloodGroups = compatibleBloodGroups[selectedBloodGroup]!;

      QuerySnapshot snapshot = await firestore
          .collection('requests')
          .where('latitude', isGreaterThanOrEqualTo: lat - latChange)
          .where('latitude', isLessThanOrEqualTo: lat + latChange)
          .where('longitude', isGreaterThanOrEqualTo: lon - lonChange)
          .where('longitude', isLessThanOrEqualTo: lon + lonChange)
          .where('bloodGroup', whereIn: validBloodGroups)
          .where('userId', isNotEqualTo: auth.currentUser?.uid)
          .get();

      List<Map<String, dynamic>> usersNearby = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((data) {
        double userLat = data['latitude'];
        double userLon = data['longitude'];
        return calculateDistance(lat, lon, userLat, userLon) <= searchRadiusKm;
      })
          .toList();

// Sort by createdAt timestamp in ascending order
      usersNearby.sort((a, b) {
        Timestamp aTime = a['createdAt'] ?? Timestamp.now();
        Timestamp bTime = b['createdAt'] ?? Timestamp.now();
        return aTime.compareTo(bTime);
      });

      setState(() {
        nearbyRequesters = usersNearby;
        isLoading = false;
      });
    } catch (e) {
      print("Error finding requesters: $e");
      setState(() {
        isLoading = false;
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
          title: const Text("Nearby Requesters",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.red[900],
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select Blood Group",
                  border: OutlineInputBorder(),
                ),
                value: selectedBloodGroup.isEmpty ? null : selectedBloodGroup,
                items: bloodGroups.map((bg) => DropdownMenuItem(
                  value: bg,
                  child: Text(bg),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBloodGroup = value!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: isLoading || selectedBloodGroup.isEmpty
                  ? null
                  : startLocationTracking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Find Nearby Requesters", style: TextStyle(color: Colors.white)),
            ),
            Expanded(
              child: nearbyRequesters.isEmpty
                  ? const Center(child: Text("No nearby requests found"))
                  : ListView.builder(
                itemCount: nearbyRequesters.length,
                itemBuilder: (context, index) {
                  final request = nearbyRequesters[index];
                  var createdAt = request['createdAt'] != null
                      ? (request['createdAt'] as Timestamp).toDate()
                      : DateTime.now();
                  var timeAgo = timeago.format(createdAt);

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 30, // Adjust size as needed
                              backgroundColor: Colors.black, // Fallback color
                              child: ClipOval(
                                child: request['profileUrl'] != null &&
                                    request['profileUrl'].isNotEmpty
                                    ? Image.network(
                                  nearbyRequesters[index]['profileUrl'],
                                  width: 100, // 2 * radius
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                    : const Icon(Icons.person,color: Colors.white,
                                    size: 40), // Display default icon if no image
                              ),
                            ),
                            title: Text(
                              nearbyRequesters[index]['name'] ?? 'Unknown',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
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
                                  "${request['bags'] ?? 'N/A'} ml needed | ${request['case'] ?? 'N/A'}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              request['userId'] != auth.currentUser!.uid
                                  ? IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(receiverId: request['userId'], receiverName: request['name']),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.message_outlined),
                              )
                                  : const SizedBox.shrink(),
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
                                        patient: request['name'],
                                        contact: request['contact'],
                                        hospital: request['hospital'],
                                        case_: request['case'],
                                        bags: request['bags'],
                                        bloodGroup: request['bloodGroup'],
                                        gender: request['gender'],
                                        email: request['email'],
                                        profileImage: request['profileUrl'],
                                        details: request['details'],
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
      ),
    );
  }
}
