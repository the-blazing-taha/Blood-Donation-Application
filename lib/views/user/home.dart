import 'package:blood/views/user/about.dart';
import 'package:blood/views/user/alldonors.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/allrequests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'globals.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 40), // Top padding for status bar
                  // Notification Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                         Get.offAll(AllRequests());
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.6),
                                    offset: Offset(4, 4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-4, -4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Get.offAll(AllRequests());
                                },
                                icon: Icon(
                                  Icons.bloodtype,
                                  color: Colors.red[900],
                                ),
                                iconSize: 28,
                              ),
                            ),

                            if (notificationCount > 0)
                              Positioned(
                                left: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                                  child: Text(
                                    '${notificationCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        )

                      ),
                    ],
                  ),
                  // Logo and Title
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset('assets/bloodbag.jpg', height: 100, width: 100),
                          const SizedBox(height: 10),
                          Text(
                            'LIFE SYNC',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                              height: 4,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'donor, at your service',
                        style: TextStyle(fontSize: 26, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    'SERVICES',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 6),
                  ),
                  const SizedBox(height: 20),
                  // Services section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ServiceCard(
                        imagePath: './assets/form.png',
                        title: 'BECOME A DONOR',
                        buttonText: 'REGISTER',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RequestDonor()),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      ServiceCard(
                        imagePath: './assets/drop.jpg',
                        title: 'FIND A DONOR',
                        buttonText: 'FIND',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllDonors()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'donor, at your service',
                    style: TextStyle(fontSize: 26, color: Colors.black54),
                  ),
                  const Spacer(),
                  const BottomNavBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String buttonText;
  final VoidCallback onPressed;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imagePath, height: 80),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[900]),
          onPressed: onPressed,
          child: Text(buttonText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.red[900],
      unselectedItemColor: Colors.black54,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
            icon: const Icon(Icons.home),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
          label: 'About Us',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            icon: const Icon(Icons.person_2_outlined),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
