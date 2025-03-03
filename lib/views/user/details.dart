import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Details extends StatefulWidget {
  final dynamic patient;
  final dynamic contact;
  final dynamic hospital;
  final dynamic residence;
  final dynamic case_;
  final dynamic bags;
  final dynamic bloodGroup;
  final dynamic gender;
  final dynamic email;
  final dynamic profileImage;

  const Details({
    super.key,
    required this.patient,
    required this.contact,
    required this.hospital,
    required this.residence,
    required this.case_,
    required this.bags,
    required this.bloodGroup,
    required this.gender,
    required this.email,
    this.profileImage,
  });

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Patient Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[900],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glowing circle
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade900,
                                  Colors.red.shade400
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          // Profile picture
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: widget.profileImage != null &&
                                  widget.profileImage.isNotEmpty
                                  ? Image.network(
                                widget.profileImage,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 80,
                                  // color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade900, Colors.red.shade400],
                          // Gradient effect
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        // Smooth rounded edges
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(2, 4), // Subtle shadow effect
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.email, color: Colors.white),
                          // White email icon
                          const SizedBox(width: 10),
                          // Spacing
                          Expanded(
                            child: Text(
                              widget.email ?? auth.currentUser?.email,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // White text for contrast
                              ),
                              overflow: TextOverflow.ellipsis,
                              // Prevents overflow
                              maxLines: 3,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
      
                  ],
                ),
              ),
              const SizedBox(height: 20),
      
              // Information Cards
              _infoCard("Patient Name", widget.patient),
              _infoCard("Gender", widget.gender),
              _infoCard("Hospital", widget.hospital),
              _infoCard("Location", widget.residence),
              _infoCard("Blood Group", widget.bloodGroup, highlight: true),
              _infoCard("Contact Number", widget.contact, copyable: true),
              _infoCard("Case", widget.case_),
              _infoCard("Quantity Needed", widget.bags.toString(), highlight: true),
              const SizedBox(height: 30),
      
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, {bool highlight = false, bool copyable = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: copyable
                    ? () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title copied to clipboard!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
                    : null,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: highlight ? Colors.red[900] : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

