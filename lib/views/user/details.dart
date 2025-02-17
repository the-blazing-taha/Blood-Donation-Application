import 'package:flutter/material.dart';

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
    return Scaffold(
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
                            widget.email,
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
            _infoCard("Contact Number", widget.contact),
            _infoCard("Case", widget.case_),
            _infoCard("Bags Needed", widget.bags.toString(), highlight: true),
            _infoCard("Urgency", "Needed Urgently", highlight: true),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }

  // Widget for displaying information inside a Card
  Widget _infoCard(String title, String value, {bool highlight = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Aligns long text correctly
          children: [
            // Title (Fixed width to prevent shifting)
            SizedBox(
              width: 120, // Adjust as needed
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),

            const SizedBox(width: 10), // Adds spacing

            // Expanded Text to handle long content
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: highlight ? Colors.red[900] : Colors.black,
                ),
                overflow: TextOverflow.ellipsis, // Truncates if needed
                maxLines: 10, // Limits height
                softWrap: true, // Allows wrapping
              ),
            ),
          ],
        ),
      ),
    );
  }

// Action Button Widget with Matching Decoration
  Widget _actionButton(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade900, Colors.red.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

