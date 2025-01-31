import 'package:flutter/material.dart';


class DonorDetails extends StatefulWidget {
  final dynamic patient;
  final dynamic contact;
  final dynamic hospital;
  final dynamic residence;
  final dynamic noOfDonations;
  final dynamic bloodGroup;
  final dynamic gender;
  final dynamic details;
  final dynamic weight;
  final dynamic  age;
  final dynamic lastDonated;
  final dynamic  donationFrequency;
  final dynamic  highestEducation;
  final dynamic  currentOccupation;
  final dynamic  currentLivingArrg;
  final dynamic eligibilityTest;
  final dynamic  futureDonationWillingness;
  const DonorDetails(
      {super.key,
        required this.patient,
        required this.contact,
        required this.hospital,
        required this.residence,
        required this.noOfDonations,
        required this.bloodGroup,
        required this.gender,
        required this.details,
        required this.weight,
        required this.age,
        required this.lastDonated,
        required this.donationFrequency,
        required this.highestEducation,
        required this.currentOccupation,
        required this.currentLivingArrg,
        required this.eligibilityTest,
        required this.futureDonationWillingness

      });

  @override
  DonorDetailsState createState() => DonorDetailsState();
}

class DonorDetailsState extends State<DonorDetails> {
  @override
  Widget build(BuildContext context) {
    final String patientName = widget.patient;
    final String contact = widget.contact;
    final String hospital = widget.hospital;
    final String residence = widget.residence;
    final int noOfdonations = widget.noOfDonations;
    final String bloodGroup = widget.bloodGroup;
    final String gender = widget.gender;
    final String details = widget.details;
    final int weight = widget.weight;
    final int age = widget.age;
    final String lastDonated = widget.lastDonated;
    final String donationFrequency = widget.donationFrequency;
    final String highestEducation = widget.highestEducation;
    final String currentOccupation = widget.currentOccupation;
    final String currentLivingArrg = widget.currentLivingArrg;
    final String eligibilityTest = widget.eligibilityTest;
    final String futureDonationWillingness = widget.futureDonationWillingness;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donor Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: Colors.red[900],
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text("Patient Name:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    patientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Location:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    residence,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Blood Group:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    bloodGroup,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Hospital:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hospital,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Gender:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    gender,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Details:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    details,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Contact Number:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    contact,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),















                const Text("Weight (Kg):"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    weight.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


                const SizedBox(
                  height: 20,
                ),
                const Text("Age:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    age.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


                const SizedBox(
                  height: 20,
                ),
                const Text("Last Donated blood:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lastDonated,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


                const SizedBox(
                  height: 20,
                ),
                const Text("Donation Frequency:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    donationFrequency,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


                const SizedBox(
                  height: 20,
                ),
                const Text("Highest Education achieved:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    highestEducation,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Text("Current Occupation:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    currentOccupation,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Current Living Arrangement:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    currentLivingArrg,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Tested for eligibility in last 6 months:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    eligibilityTest,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),



                const SizedBox(
                  height: 20,
                ),
                const Text("Number of donations done:"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    noOfdonations.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Would Donate in future? :"),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    futureDonationWillingness,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),








                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      // Respond to button press
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[900], // Background color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120, vertical: 10), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10), // Rounded corners
                      ),
                      elevation: 5, // Shadow elevation
                    ),
                    child: const Text(
                      'Call',
                      style: TextStyle(
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      // Respond to button press
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red[900],
                      // backgroundColor: , // Background color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10), // Rounded corners
                      ),
            
                      elevation: 5, // Shadow elevation
                    ),
                    child: const Text(
                      'Message',
                      style: TextStyle(
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
