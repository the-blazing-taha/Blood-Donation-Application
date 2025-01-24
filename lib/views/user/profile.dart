import 'package:blood/views/user/details.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'donors_list.dart';
import 'home.dart';
import 'my_requests.dart';

class Profile extends StatefulWidget {

  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    // Filter the list based on search query
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              splashRadius: 10,
              padding: const EdgeInsets.all(1.0),
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            )
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
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
                    Icons.people,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'All Donors',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  selected: _selectedIndex == 2,
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonorList(),
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
                    Icons.request_page,
                    color: Colors.white,
                  ),
                  title: const Text('Add Blood Request',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  selected: _selectedIndex == 4,
                  onTap: () {
                    _onItemTapped(4);
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
                  selected: _selectedIndex == 5,
                  onTap: () {
                    _onItemTapped(5);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    );
                  },
                ),
                // Other ListTiles...
              ],
            ),
          ),
        ),




       body: Text('${user?.email} ${user?.uid}')
    );
  }
}