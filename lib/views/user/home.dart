import 'package:blood/views/user/about.dart';
import 'package:blood/views/user/alldonors.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/allrequests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:badges/badges.dart' as badges; // Import the badges package

// Assuming this is your global variable.  It's better to manage this with a state management solution.
int notificationCount = 0; //changed to 3 to show the badge

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE0E0), // Light pink
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Increased horizontal padding
            child: Column(
              children: [
                // Top row with notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Get.offAll(AllRequests()),
                      child: badges.Badge(
                        badgeContent: Text(
                          '$notificationCount',
                          style: const TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        showBadge: notificationCount > 0, // Show badge if count > 0
                        badgeAnimation: const badges.BadgeAnimation.fade(
                          animationDuration: Duration(milliseconds: 300),
                          toAnimate: true,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12), // Increased padding
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.shade100,
                                blurRadius: 12, // Increased blur radius
                                offset: const Offset(4, 6), // Increased offset
                              ),
                            ],
                          ),
                          child: Icon(Icons.bloodtype,
                              color: Colors.red[900], size: 32), // Increased size
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Logo and app title
                Row(
                  children: [
                    Image.asset('assets/bloodbag.png', height: 100, width: 100), // Increased size
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIFE SYNC',
                          style: GoogleFonts.poppins( // Using Google Fonts
                            fontSize: 32, // Increased font size
                            fontWeight: FontWeight.w800, // Use a heavier font weight
                            color: Colors.red[900],
                            letterSpacing: 3, // Increased letter spacing
                          ),
                        ),
                        Text(
                          'Donate Blood, Save Lives', // Changed slogan
                          style: GoogleFonts.poppins(
                            fontSize: 13, // Increased font size
                            color: Colors.black87, // Darker shade
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Services header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Text(
                      'SERVICES',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Services section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ServiceCard(
                      imagePath: 'assets/form.png',
                      title: 'BECOME A DONOR',
                      buttonText: 'REGISTER',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => RequestDonor()));
                      },
                    ),
                    ServiceCard(
                      imagePath: 'assets/drop.jpg',
                      title: 'FIND A DONOR',
                      buttonText: 'FIND',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AllDonors()));
                      },
                    ),
                  ],
                ),

                const Spacer(),
                Text(
                  'Every drop counts, be a hero.', // Changed tagline
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic, // Added italic
                  ),
                ),
                const SizedBox(height: 20),

                // Bottom Navigation
                NavigationBar(
                  height: 70, // Increased height
                  backgroundColor: Colors.white,
                  indicatorColor: Colors.red[100],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => selectedIndex = index);
                    switch (index) {
                      case 0:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const Home()));
                        break;
                      case 1:
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AboutUsPage()));
                        break;
                      case 2:
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Profile()));
                        break;
                    }
                  },
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.home, size: 30), // Increased size
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.info_outline, size: 30),
                      label: 'About',
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.person, size: 30),
                      label: 'Profile',
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
    return Container(
      width: 150, // Increased width
      padding: const EdgeInsets.all(18), // Increased padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20), // Increased radius
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade100,
            blurRadius: 12, // Increased blur radius
            offset: const Offset(4, 6), // Increased offset
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(imagePath, height: 70), // Increased height
          const SizedBox(height: 15), // Increased spacing
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins( // Using Google Fonts
              fontSize: 15, // Increased font size
              fontWeight: FontWeight.w600, // Use semibold
            ),
          ),
          const SizedBox(height: 12), // Increased spacing
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Increased radius
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), //added padding
            ),
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: GoogleFonts.poppins( // Using Google Fonts
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

