import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/fireStoreDatabaseController.dart';
import 'globals.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get();
    final AuthController authController = AuthController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Handle errors
                } else if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic>? userData = snapshot.data!.data();
                  String? profileImageUrl = userData?['profileImage'];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 55, // Adjust size as needed
                        backgroundColor: Colors.grey[300], // Fallback color
                        child: ClipOval(
                          child: profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? Image.network(
                                  profileImageUrl,
                                  width: 100, // 2 * radius
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person,
                                  size: 80), // Display default icon if no image
                        ),
                      ),
                    ],
                  );
                } else {
                  return const CircleAvatar(
                    radius: 70,
                    child: Icon(
                      Icons.person,
                      size: 80,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Handle errors
                } else if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic>? userData = snapshot.data!.data();
                  String? userName = userData?['fullName'];
                  return Column(
                    children: [
                      Text(
                        userName as String,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  );
                } else {
                  return const Text('No user data found.');
                }
              },
            ),
            Text(
              auth.currentUser?.email as String,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {
                // Show confirmation dialog when logout is pressed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.white,
                      title: Text(
                        'Confirm Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red[900],
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to log out?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // If user presses "No", close the dialog
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.red[900], // White text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // If user presses "Yes", log out and show snackbar
                            try {
                              authController.signout(); // Call signout function
                              Navigator.of(context).pop(); // Close the dialog

                            } catch (e) {
                              Navigator.of(context).pop(); // Close the dialog
                              Get.snackbar(
                                "Error:",
                                e.toString(),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(15),
                                snackPosition: SnackPosition.BOTTOM,
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}



class _SettingsState extends State<Settings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStoreDatabaseController _firebaseDatabase = fireStoreDatabaseController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool donorMode = false;
  File? _profileImage;
  String? _fullName;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDonorMode();
    fetchUserInfo();
  }

  void fetchDonorMode() async {
    bool? mode = await _firebaseDatabase.getProfileDonorMode();
    if (mounted) {
      setState(() {
        donorMode = mode ?? false;
      });
    }
  }

  void fetchUserInfo() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();

    if (userDoc.exists) {
      var data = userDoc.data();
      setState(() {
        _fullName = data?['fullName'];
        _nameController.text = _fullName ?? '';
      });
    }
  }

  Future<void> updateUserInfo() async {
    String? downloadUrl;

    // Upload profile image if new one is selected
    if (_profileImage != null) {
      String fileName = "${_auth.currentUser!.uid}_profile.jpg";
      UploadTask uploadTask = FirebaseStorage.instance
          .ref('profileImages/$fileName')
          .putFile(_profileImage!);
      TaskSnapshot snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();
    }

    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Update name in 'users' collection and 'profileImage' if new one is provided
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fullName': _nameController.text.trim(),
      if (downloadUrl != null) 'profileImage': downloadUrl,
    });

    // Prepare updates for other collections
    final otherCollectionUpdates = {
      'fullName': _nameController.text.trim(),
      if (downloadUrl != null) 'profileUrl': downloadUrl,
    };

    // Update 'donors' collection documents where userId == uid
    var donorSnapshot = await FirebaseFirestore.instance
        .collection('donors')
        .where('userId', isEqualTo: uid)
        .get();

    for (var doc in donorSnapshot.docs) {
      await doc.reference.update(otherCollectionUpdates);
    }

    // Update 'requests' collection documents where userId == uid
    var requestSnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: uid)
        .get();

    for (var doc in requestSnapshot.docs) {
      await doc.reference.update(otherCollectionUpdates);
    }

    // Show confirmation
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 4),
    );
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  Future<String?> getDocIDByName() async {
    var collection = FirebaseFirestore.instance.collection('donors');
    var querySnapshot = await collection
        .where('userId', isEqualTo: auth.currentUser?.uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// --- Profile Card ---
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade200, Colors.red.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.camera_alt, size: 35, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    _fullName ?? 'Your Name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            /// --- Name Input Field ---
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 20),

            /// --- Update Profile Button ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.save),
                label: Text("Update Profile", style: TextStyle(fontSize: 16)),
                onPressed: updateUserInfo,
              ),
            ),

            SizedBox(height: 30),

            /// --- Donor Mode Switch ---
            buildCustomSwitch(
              title: "Donor Mode",
              value: donorMode,
              onChanged: (bool value) async {
                String? docID = await getDocIDByName();
                if (docID != null) {
                  setState(() {
                    donorMode = value;
                  });
                  await _firebaseDatabase.updateDonorMode(docID, donorMode);
                  donorMode
                      ? Get.snackbar(
                    'Donor mode enabled',
                    'You will be shown as donor to everyone!',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 6),
                    margin: const EdgeInsets.all(15),
                    icon: const Icon(Icons.message, color: Colors.white),
                  )
                      : Get.snackbar(
                    'Donor mode disabled',
                    'You will not be shown as donor to everyone!',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 6),
                    margin: const EdgeInsets.all(15),
                    icon: const Icon(Icons.message, color: Colors.white),
                  );
                } else {
                  Get.snackbar(
                    'Donation Form not filled',
                    'To turn the donor mode on, fill the donation form!',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 6),
                    margin: const EdgeInsets.all(15),
                    icon: const Icon(Icons.message, color: Colors.white),
                  );
                }
              },
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color activeColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        title: Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
        ),
      ),
    );
  }
}
