import 'dart:core';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/auth_controller.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth= FirebaseAuth.instance;
    final user=FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).get();
    final AuthController authController = AuthController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white,),
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
                        backgroundColor: Colors.yellow[600], // Fallback color
                        child: ClipOval(
                          child: profileImageUrl != null && profileImageUrl.isNotEmpty
                              ? Image.network(
                            profileImageUrl,
                            width: 100, // 2 * radius
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.person, size: 40), // Display default icon if no image
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
                      Text(userName as String, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20 ),),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );},
            ),
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.blue),
              title: Text('Billing Details'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.group, color: Colors.blue),
              title: Text('User Management'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('Information'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {authController.signout();},
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
   EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
   final AuthController _authController = AuthController();

   Uint8List? _image;

   selectGalleryImage() async {
     Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);
     if (mounted) {
       setState(() {
         _image = im;
       });
     }
   }

   captureImage() async {
     Uint8List im = await _authController.pickProfileImage(ImageSource.camera);
     if (mounted) {
       setState(() {
         _image = im;
       });
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_placeholder.png'), // Replace with your image asset
              child: Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.yellow,
                  child: Icon(Icons.camera_alt, size: 16, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'E-Mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            // SizedBox(height: 15),
            // TextField(
            //   decoration: InputDecoration(
            //     prefixIcon: Icon(Icons.phone),
            //     labelText: 'Phone No',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //   ),
            // ),
            SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}



class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthController _authController = AuthController();

  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);
    if (mounted) {
      setState(() {
        _image = im;
      });
    }
  }

  captureImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.camera);
    if (mounted) {
      setState(() {
        _image = im;
      });
    }
  }
  static const WidgetStateProperty<Icon> thumbIcon =
  WidgetStateProperty<Icon>.fromMap(
    <WidgetStatesConstraint, Icon>{
      WidgetState.selected: Icon(Icons.check),
      WidgetState.any: Icon(Icons.close),
    },
  );
  bool light0 = true;
  bool light1 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: light0,
              onChanged: (bool value) {
                setState(() {
                  light0 = value;
                });
              },
            ),
            Switch(
              thumbIcon: thumbIcon,
              value: light1,
              onChanged: (bool value) {
                setState(() {
                  light1 = value;
                });
              },
            ),



          ],
        ),
      ),
    );
  }
}
