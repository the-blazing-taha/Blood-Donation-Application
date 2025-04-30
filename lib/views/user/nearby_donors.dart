import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/fireStoreDatabaseController.dart';
import 'chat_screen.dart';
import 'donor_details.dart';

class NearbyDonors extends StatefulWidget {
  const NearbyDonors({super.key});
  static const route = '/nearby-donors';

  @override
  State<NearbyDonors> createState() => _NearbyDonorsState();
}

class _NearbyDonorsState extends State<NearbyDonors> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fireStoreDatabaseController firebaseDatabase =
  fireStoreDatabaseController();
  Position? currentPosition;
  List<Map<String, dynamic>> nearbyDonors = [];
  bool isLoading = false;
  String selectedBloodGroup = '';
  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  final Map<String, List<String>> compatibleBloodGroups = {
    'A+': ['A+', 'A-', 'O+', 'O-'],
    'A-': ['A-', 'O-'],
    'B+': ['B+', 'B-', 'O+', 'O-'],
    'B-': ['B-', 'O-'],
    'O+': ['O+', 'O-'],
    'O-': ['O-'],
    'AB+': ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
    'AB-': ['A-', 'B-', 'O-', 'AB-'],
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

      await findNearbyDonors();
    } catch (e) {
      print("Error getting location: $e");
    }
  }


  Future<bool> doesUserExist() async {
    final doc = await FirebaseFirestore.instance
        .collection('donors')
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

  Future<void> findNearbyDonors() async {
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
          .collection('donors')
          .where('latitude', isGreaterThanOrEqualTo: lat - latChange)
          .where('latitude', isLessThanOrEqualTo: lat + latChange)
          .where('longitude', isGreaterThanOrEqualTo: lon - lonChange)
          .where('longitude', isLessThanOrEqualTo: lon + lonChange)
          .where('activity', isEqualTo: true)
          .where('bloodGroup', whereIn: validBloodGroups)
          .where('userId', isNotEqualTo: auth.currentUser?.uid)
          .get();

      List<Map<String, dynamic>> usersNearby = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((data) {
        double userLat = data['latitude'];
        double userLon = data['longitude'];
        return calculateDistance(lat, lon, userLat, userLon) <= searchRadiusKm;
      }).toList();
      usersNearby.sort((a, b) {
        Timestamp aTime = a['createdAt'] ?? Timestamp.now();
        Timestamp bTime = b['createdAt'] ?? Timestamp.now();
        return aTime.compareTo(bTime);
      });
      setState(() {
        nearbyDonors = usersNearby;
        isLoading = false;
      });
    } catch (e) {
      print("Error finding donors: $e");
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
          title: const Text("Nearby Donors",
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
                  : const Text("Find Nearby Donors", style: TextStyle(color: Colors.white)),
            ),
            Expanded(
              child: nearbyDonors.isEmpty
                  ? const Center(child: Text("No nearby donors found"))
                  : ListView.builder(
                itemCount: nearbyDonors.length,
                itemBuilder: (context, index) {
                  final donor = nearbyDonors[index];
                  var createdAt = donor['createdAt'] != null
                      ? (donor['createdAt'] as Timestamp).toDate()
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
                                nearbyDonors[index]['bloodGroup'] ?? 'N/A',
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
                                child: donor['profileUrl'] != null &&
                                    donor['profileUrl'].isNotEmpty
                                    ? Image.network(
                                  nearbyDonors[index]['profileUrl'],
                                  width: 100, // 2 * radius
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                    : const Icon(Icons.person,color: Colors.white,
                                    size: 40), // Display default icon if no image
                              ),
                            ),
                            title: Text(
                              nearbyDonors[index]['name'] ?? 'Unknown',
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
                                        nearbyDonors[index]['residence'] ?? 'Unknown',
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${donor['gender'] ?? 'N/A'} | ${donor['donations_done'] ?? '0'} donations done",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              donor['userId'] != auth.currentUser!.uid
                                  ? IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(receiverId: donor['userId'], receiverName: donor['name']),
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
                                      builder: (context) => DonorDetails(
                                        patient: donor['name'],
                                        contact: donor['contact'],
                                        residence: donor['residence'],
                                        bloodGroup: donor['bloodGroup'],
                                        gender: donor['gender'],
                                        noOfDonations: donor['donations_done'],
                                        details: donor['details'],
                                        weight: donor['weight'],
                                        age: donor['age'],
                                        lastDonated: donor['lastDonated'],
                                        donationFrequency: donor['donationFrequency'],
                                        highestEducation: donor['highestEducation'],
                                        currentOccupation: donor['currentOccupation'],
                                        currentLivingArrg: donor['currentLivingArrg'],
                                        eligibilityTest: donor['eligibilityTest'],
                                        futureDonationWillingness: donor['futureDonationWillingness'],
                                        email: donor['profileUrl'],

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
