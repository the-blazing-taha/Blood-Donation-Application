import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timeago/timeago.dart' as timeago;

class NearbyRequestors extends StatefulWidget {
  const NearbyRequestors({super.key});
  static const route = '/nearby-requestors';

  @override
  State<NearbyRequestors> createState() => _NearbyRequestorsState();
}

class _NearbyRequestorsState extends State<NearbyRequestors> {



  final FirebaseAuth auth = FirebaseAuth.instance;
  Position? currentPosition;
  List<Map<String, dynamic>> nearbyRequestors = [];
  bool isLoading = false;
  String selectedBloodGroup = '';

  final List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  final Map<String, List<String>> compatibleBloodGroups = {
    'A+': ['A+', 'AB+'],
    'A-': ['A+', 'A-', 'AB+', 'AB-'],
    'B+': ['B+', 'AB+'],
    'B-': ['B+', 'B-', 'AB+', 'AB-'],
    'O+': ['O+', 'A+', 'B+', 'AB+'],
    'O-': ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'],
    'AB+': ['AB+'],
    'AB-': ['AB+', 'AB-']
  };

  Future<void> startLocationTracking() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
        isLoading = true;
      });

      await findNearbyRequestors();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  Future<void> findNearbyRequestors() async {
    if (currentPosition == null || selectedBloodGroup.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    double lat = currentPosition!.latitude;
    double lon = currentPosition!.longitude;
    double searchRadiusKm = 5;
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
          .get();

      List<Map<String, dynamic>> requestorsNearby = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((data) {
        double userLat = data['latitude'];
        double userLon = data['longitude'];
        return calculateDistance(lat, lon, userLat, userLon) <= searchRadiusKm;
      }).toList();

      setState(() {
        nearbyRequestors = requestorsNearby;
        isLoading = false;
      });
    } catch (e) {
      print("Error finding requestors: $e");
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
          title: const Text("Nearby Blood Requestors",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.red[900],
          centerTitle: true,
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
                  : const Text("Find Nearby Requestors", style: TextStyle(color: Colors.white)),
            ),
            Expanded(
              child: nearbyRequestors.isEmpty
                  ? const Center(child: Text("No nearby requestors found"))
                  : ListView.builder(
                itemCount: nearbyRequestors.length,
                itemBuilder: (context, index) {
                  final requestor = nearbyRequestors[index];
                  var createdAt = requestor['createdAt'] != null
                      ? (requestor['createdAt'] as Timestamp).toDate()
                      : DateTime.now();
                  var timeAgo = timeago.format(createdAt);
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(requestor['name'] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Requested ${requestor['bloodGroup']} blood $timeAgo"),
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
