import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';


class fireStoreDatabaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<String> addInventory(String name, String bloodGroup, int number, double concentration,String gender,double hemoglobin)async{
    DocumentReference inventory = firestore.collection('inventory').doc();
    String res;
   try {
     await inventory.set({
       'inventoryId': inventory.id,
       'inventoryName': name,
       'bloodGroup': bloodGroup,
       'inventoryNumber': number,
       'concentration': concentration,
       'gender': gender,
       'haemoglobin': hemoglobin,
       'createdAt':Timestamp.now(),
       'isExpired': false
     });
      res = "Inventory added successfully!";
   }
   catch(e){
     res = e.toString();
   }
   return res;
  }

  Future<String> addRequest(
      String name,
      String? contact,
      String? hospital,
      String case_,
      int bags,
      String bloodGroup,
      String gender,
      String? details) async {
    String res = "Something went wrong while uploading the request!";
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      String? profileUrl = await getProfileUrl();
      // Get the FCM token
      // String? fcmToken = await FirebaseMessaging.instance.getToken();
      // print("User FCM Token: $fcmToken");
      DocumentReference requestRef = firestore.collection('requests').doc();
      await requestRef.set({
        'docId': requestRef.id,
        'userId': _auth.currentUser?.uid,
        'name': name,
        'contact': contact,
        'hospital': hospital?.trim(),
        'case': case_,
        'bags': bags,
        'bloodGroup': bloodGroup,
        'gender': gender,
        'details': details?.trim(),
        'longitude': position.longitude,
        'latitude': position.latitude,
        'createdAt': Timestamp.now(),
        'profileUrl': profileUrl ?? "",
        'email': _auth.currentUser?.email

      });
      res = "Request added successfully!";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<String?> getProfileUrl() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();

    if (userDoc.exists) {
      return userDoc.data()?['profileImage']; // Get 'profileUrl' field
    }
    return null; // Return null if no document found
  }
  Future<bool> getProfileDonorMode() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('donors')
        .doc(_auth.currentUser?.uid)
        .get();

    if (userDoc.exists) {
      return userDoc.data()?['activity'] ?? false; // Default to false
    }
    return false; // Return false instead of null
  }



  Future<String> addDonor(
      String name,
      String? contact,
      String? residence,
      int donationNumber,
      String bloodGroup,
      String gender,
      String? details,
      int weight,
      int age,
      String lastDonated,
      String firstDonated,
      String donationFrequency,
      String highestEducation,
      String currentOccupation,
      String currentLivingArrg,
      String eligibilityTest,
      String futureDonationWillingness) async {
    String res = "Something went wrong while uploading the donation !";
    try {
      Position position = await _determinePosition();
      DocumentReference donorRef = firestore.collection('donors').doc(_auth.currentUser?.uid);
      String? profileUrl = await getProfileUrl();

      await donorRef.set({
        'docId': donorRef.id,
        'userId': _auth.currentUser?.uid,
        'name': name,
        'contact': contact,
        'residence': residence,
        'donations_done': donationNumber,
        'bloodGroup': bloodGroup,
        'gender': gender,
        'details': details,
        'weight': weight,
        'age': age,
        'lastDonated': lastDonated,
        'firstDonated': firstDonated,
        'donationFrequency': donationFrequency,
        'highestEducation': highestEducation,
        'currentOccupation': currentOccupation,
        'currentLivingArrg': currentLivingArrg,
        'eligibilityTest': eligibilityTest,
        'futureDonationWillingness': futureDonationWillingness,
        'latitude':position.latitude,
        'longitude': position.longitude,
        'createdAt': Timestamp.now(),
        'activity' :true,
        'profileUrl':profileUrl,
        'email': _auth.currentUser?.email
      });
      res = "Donation appeal added successfully!";
    } catch (e) {
      res = e.toString();
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
    return res;
  }

  Future<void> deleteDonation(String docId)async {
    try {
      firestore
          .collection('donors')
          .where(
          'docId', isEqualTo: docId) // Query documents where docId matches
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete(); // Delete each matching document
        }
      });
    }
    catch(e){
      print("ERROR: $e");
    }
  }

  Future<void> deleteRequest(String docId)async {
    try {

      firestore
          .collection('requests')
          .where(
          'docId', isEqualTo: docId) // Query documents where docId matches
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete(); // Delete each matching document
        }
      });
    }
    catch(e){
      print("ERROR: $e");
    }
  }

  Future<void> updateDonorPosition(double longitude,double latitude)async{
   await firestore.collection('donors')
        .doc(_auth.currentUser?.uid)
        .update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<void> updateRequesterPosition(double longitude,double latitude)async{
    await firestore.collection('requests')
        .doc(_auth.currentUser?.uid)
        .update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<void> updateRequest(
      {required String docId,
        String name = '',
        String contact = '',
        String hospital = '',
        String case_ = '',
        int bags = -1,
        String bloodGroup = '',
        String gender = '',
        String details=''
      }) async {

    try {
      if (name != '') {
        firestore.collection('requests')
            .doc(docId)
            .update({
          'name': name,
        });
      }
      if (contact != '') {
        firestore.collection('requests')
            .doc(docId)
            .update({
          'contact': contact,
        });
      }
      if (case_ != '') {
        firestore.collection('requests')
            .doc(docId)
            .update({
          'case': case_,
        });
      }
      if (bags != -1) {
        firestore.collection('requests')
            .doc(docId)
            .update({
          'bags': bags,
        });
      }
      if (bloodGroup != '') {
        firestore.collection('requests')
            .doc(docId)
            .update({
          'bloodGroup': bloodGroup,
        });
      }
      if (gender != '') {
        firestore.collection('requests')
            .doc(docId)
            .update({
          'gender': gender,
        });
      }
      if (details != '') {
        firestore.collection('requests')
            .doc(docId)
            .update({
          'details': details,
        });
      }
      if (hospital != '') {
        firestore.collection('requests')
            .doc(docId)
            .update({
          'hospital': hospital,
        });
      }
    } catch (e) {
      debugPrint("ERROR IN UPDATING REQUEST: $e");
    }
  }

  Future<void> updateDonationAppeal(
      {required String docId,
        String name = '',
        String contact = '',
        String hospital = '',
        String residence = '',
        int donationsDone = -1,
        String bloodGroup = '',
        String gender = '',
        String details='',
        int weight=-1,
        String firstDonation = '',
        String lastDonation = '',
        int age=-1,
        String donationFrequency='',
        String highestEducation='',
        String currentOccupation='',
        String currentLivingArrg='',
        String eligibilityTest='',
        String futureDonationWillingness=''}) async {
    try {
      if (name != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'name': name,
        });
      }
      if (contact != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'contact': contact,
        });
      }

      if (donationsDone != -1) {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'donations_done': donationsDone,
        });
      }

      if (residence != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'residence': residence,
        });
      }
      if (bloodGroup != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'bloodGroup': bloodGroup,
        });
      }
      if (gender != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'gender': gender,
        });
      }

      if (details != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'details': details,
        });
      }
      if (hospital != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'hospital': hospital,
        });
      }

      if (lastDonation != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'lastDonated': lastDonation,
        });
      }
      if (firstDonation != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'firstDonated': firstDonation,
        });
      }
      if (age != -1) {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'age': age,
        });
      }

      if (weight != -1) {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'weight': weight,
        });
      }

      if (donationFrequency != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'donationFrequency': donationFrequency,
        });
      }
      if (highestEducation != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'highestEducation': highestEducation,
        });
      }
      if (currentOccupation != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'currentOccupation': currentOccupation,
        });
      }
      if (currentLivingArrg != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'currentLivingArrg': currentLivingArrg,
        });
      }

      if (eligibilityTest != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'eligibilityTest': eligibilityTest,
        });
      }
      if (futureDonationWillingness != '') {
        firestore.collection('donors')
            .doc(docId)
            .update({
          'futureDonationWillingness': futureDonationWillingness,
        });
      }
    } catch (e) {
      debugPrint("ERROR IN UPDATING DONATION APPEAL: $e");
    }
  }

  Future<void> updateDonorMode(String docId, bool mode) async {
    await FirebaseFirestore.instance.collection('donors')
        .doc(docId)
        .update({'activity': mode});
  }

  Stream<bool> doesDonorExist(String userId) {
    return FirebaseFirestore.instance
        .collection('donors')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty); // Convert to true/false
  }

  Future<void> deleteInventory(String docId)async {
    try {
      firestore
          .collection('inventory')
          .where(
          'inventoryId', isEqualTo: docId) // Query documents where docId matches
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete(); // Delete each matching document
        }
      });
    }
    catch(e){
      print("ERROR: $e");
    }
  }
  Future<void> removeInventoryColor(String docId)async {
    firestore.collection('inventory')
        .doc(docId)
        .update({
      'isExpired': true,
    });
  }
}






