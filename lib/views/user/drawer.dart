import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import 'alldonors.dart';
import 'allrequests.dart';
import 'chats_user_screen.dart';
import 'home.dart';
import 'my_donation_appeal.dart';
import 'my_requests.dart';
import 'nearby_donors.dart';
import 'nearby_requestors.dart';

class SideDrawer extends StatefulWidget {
  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  int selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthController _authController = AuthController();

  Future<DocumentSnapshot<Map<String, dynamic>>>? userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser ?.uid).get();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Drawer(
        backgroundColor: Colors.red[900],
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.27,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.red[900]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Life Sync',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: userFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error loading user data.');
                            } else if (snapshot.hasData && snapshot.data!.exists) {
                              Map<String, dynamic>? userData = snapshot.data!.data();
                              String? profileImageUrl = userData?['profileImage'];
                              String? userName = userData?['fullName'];

                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.1,
                                    backgroundColor: Colors.grey[300],
                                    child: ClipOval(
                                      child: profileImageUrl != null && profileImageUrl.isNotEmpty
                                          ? Image.network(
                                        profileImageUrl,
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        height: MediaQuery.of(context).size.width * 0.2,
                                        fit: BoxFit.cover,
                                      )
                                          : const Icon(Icons.person, size: 40),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    userName ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Pacifico',
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            } else {
                              return const Text('No user data found.');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildDrawerItem(Icons.home, 'Home', 0, context, Home()),
                    _buildDrawerItem(Icons.bloodtype, 'Your Requests', 1, context, const Requests()),
                    _buildDrawerItem(Icons.bloodtype, 'Register as Donor', 3, context, const RequestDonor()),
                    _buildDrawerItem(Icons.person, 'Your Donation Registration', 4, context, const DonationAppeal()),
                    _buildDrawerItem(Icons.request_page, 'Add Blood Request', 5, context, const RequestForm()),
                    _buildDrawerItem(Icons.request_page, 'Profile', 6, context, Profile()),
                    _buildDrawerItem(Icons.near_me, 'Nearby Donors', 7, context, const NearbyDonors()),
                    _buildDrawerItem(Icons.near_me_outlined, 'Nearby Requesters', 8, context, const NearbyRequestors()),
                    _buildDrawerItem(Icons.list_outlined, 'All Requesters', 9, context, const AllRequests()),
                    _buildDrawerItem(Icons.list, 'All Donors', 10, context, AllDonors()),
                    _buildDrawerItem(Icons.message_outlined, 'Messages', 11, context, ChatUsersScreen()),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.white),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      selected: selectedIndex == 11,
                      onTap: () {
                        onItemTapped(11);
                        Navigator.pop(context);
                        _authController.signout();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index, BuildContext context, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      selected: selectedIndex == index,
      onTap: () {
        onItemTapped(index);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}