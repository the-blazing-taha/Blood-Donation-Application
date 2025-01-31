import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class fireStoreDatabaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addRequest(
      String name,
      String contact,
      String hospital,
      String residence,
      String case_,
      int bags,
      String bloodGroup,
      String gender,
      String details) async {
    String res = "Something went wrong while uploading the request!";
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      DocumentReference requestRef = _firestore.collection('requests').doc();
      await requestRef.set({
        'docId': requestRef.id,
        'userId': _auth.currentUser?.uid,
        'name': name,
        'contact': contact,
        'hospital': hospital,
        'residence': residence,
        'case': case_,
        'bags': bags,
        'bloodGroup': bloodGroup,
        'gender': gender,
        'details': details,
        'longitude': position.longitude,
        'latitude': position.latitude
      });
      res = "Request added successfully!";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> addDonor(
      String name,
      String contact,
      String hospital,
      String residence,
      int donationNumber,
      String bloodGroup,
      String gender,
      String details,
      int weight,
      int age,
      String lastDonated,
      String donationFrequency,
      String highestEducation,
      String currentOccupation,
      String currentLivingArrg,
      String eligibilityTest,
      String futureDonationWillingness) async {
    String res = "Something went wrong while uploading the donation !";
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      DocumentReference donorRef = _firestore.collection('donors').doc(_auth.currentUser?.uid);
      await donorRef.set({
        'docId': donorRef.id,
        'userId': _auth.currentUser?.uid,
        'name': name,
        'contact': contact,
        'hospital': hospital,
        'residence': residence,
        'donations_done': donationNumber,
        'bloodGroup': bloodGroup,
        'gender': gender,
        'details': details,
        'weight': weight,
        'age': age,
        'lastDonated': lastDonated,
        'donationFrequency':  donationFrequency,
        'highestEducation':  highestEducation,
        'currentOccupation':  currentOccupation,
        'currentLivingArrg':  currentLivingArrg,
        'eligibilityTest':  eligibilityTest,
        'futureDonationWillingness':  futureDonationWillingness,
        'latitude':position.latitude,
        'longitude': position.longitude
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
      _firestore
          .collection('donations')
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
      _firestore
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

  Future<void> updateDonorPosition(double longitude, latitude)async{
    _firestore.collection('donors')
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
        String residence = '',
        String case_ = '',
        int bags = -1,
        String bloodGroup = '',
        String gender = '',
        String details=''
      }) async {

    try {
      if (name != '') {
        _firestore.collection('requests')
            .doc(docId)
            .update({
          'name': name,
        });
      }
      if (contact != '') {
        _firestore.collection('requests')
            .doc(docId)
            .update({
          'contact': contact,
        });
      }

      if (case_ != '') {
        _firestore.collection('requests')
            .doc(docId)
            .update({
          'case': case_,
        });
      }

      if (residence != '') {
        _firestore.collection('requests')
            .doc(docId)
            .update({
          'residence': residence,
        });
      }
      if (bags != -1) {
        _firestore.collection('requests')
            .doc(docId)
            .update({
          'bags': bags,
        });
      }
      if (bloodGroup != '') {
        _firestore.collection('requests')
            .doc(docId)
            .update({
          'bloodGroup': bloodGroup,
        });
      }
      if (gender != '') {
        _firestore.collection('requests')
            .doc(docId)
            .update({
          'gender': gender,
        });
      }

      if (details != '') {
        _firestore.collection('requests')
            .doc(docId)
            .update({
          'details': details,
        });
      }
      if (hospital != '') {
        _firestore.collection('requests')
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
        int age=-1,
        String lastDonated='',
        String donationFrequency='',
        String highestEducation='',
        String currentOccupation='',
        String currentLivingArrg='',
        String eligibilityTest='',
        String futureDonationWillingness=''}) async {
    try {
      if (name != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'name': name,
        });
      }
      if (contact != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'contact': contact,
        });
      }

      if (donationsDone != -1) {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'donations_done': donationsDone,
        });
      }

      if (residence != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'residence': residence,
        });
      }
      if (bloodGroup != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'residence': residence,
        });
      }
      if (gender != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'gender': gender,
        });
      }

      if (details != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'details': details,
        });
      }
      if (hospital != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'hospital': hospital,
        });
      }

      if (lastDonated != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'lastDonated': lastDonated,
        });
      }

      if (age != -1) {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'age': age,
        });
      }

      if (weight != -1) {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'weight': weight,
        });
      }

      if (donationFrequency != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'donationFrequency': donationFrequency,
        });
      }
      if (highestEducation != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'highestEducation': highestEducation,
        });
      }
      if (currentOccupation != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'currentOccupation': currentOccupation,
        });
      }
      if (currentLivingArrg != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'currentLivingArrg': currentLivingArrg,
        });
      }

      if (eligibilityTest != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'eligibilityTest': eligibilityTest,
        });
      }
      if (futureDonationWillingness != '') {
        _firestore.collection('donors')
            .doc(docId)
            .update({
          'futureDonationWillingness': futureDonationWillingness,
        });
      }
    } catch (e) {
      debugPrint("ERROR IN UPDATING DONATION APPEAL: $e");
    }
  }



}
