import 'package:blood/views/user/drawer.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer:  SideDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/bag.png', height: 150),
            const SizedBox(height: 20),
            Text(
              'Welcome to Life Sync',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Life Sync is dedicated to connecting blood donors with those in need. Our mission is to make blood donation easier, faster, and more accessible to save lives.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Text(
              'Why Choose Us?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            const SizedBox(height: 10),
            const BulletPoint(text: 'Find and connect with nearby donors instantly'),
            const BulletPoint(text: 'Get notified about urgent blood requests'),
            const BulletPoint(text: 'Easy and quick donor registration process'),
            const BulletPoint(text: 'Secure and trusted donation platform'),
            const SizedBox(height: 30),
            Text(
              'Blood Group Compatibility',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            const SizedBox(height: 10),
            const CompatibilityTable(),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Colors.red[900], size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class CompatibilityTable extends StatelessWidget {
  const CompatibilityTable({super.key});

  final List<Map<String, dynamic>> compatibility = const [
    {
      'group': 'O-',
      'donate': 'All blood types',
      'receive': 'O- only',
    },
    {
      'group': 'O+',
      'donate': 'O+, A+, B+, AB+',
      'receive': 'O+, O-',
    },
    {
      'group': 'A-',
      'donate': 'A-, A+, AB-, AB+',
      'receive': 'A-, O-',
    },
    {
      'group': 'A+',
      'donate': 'A+, AB+',
      'receive': 'A+, A-, O+, O-',
    },
    {
      'group': 'B-',
      'donate': 'B-, B+, AB-, AB+',
      'receive': 'B-, O-',
    },
    {
      'group': 'B+',
      'donate': 'B+, AB+',
      'receive': 'B+, B-, O+, O-',
    },
    {
      'group': 'AB-',
      'donate': 'AB-, AB+',
      'receive': 'A-, B-, AB-, O-',
    },
    {
      'group': 'AB+',
      'donate': 'AB+ only',
      'receive': 'All blood types (Universal Recipient)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: compatibility
          .map(
            (row) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🩸 Blood Group: ${row['group']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  'Can Donate To: ${row['donate']}',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  'Can Receive From: ${row['receive']}',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
