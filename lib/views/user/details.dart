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

  const Details(
      {super.key,
      required this.patient,
      required this.contact,
      required this.hospital,
      required this.residence,
      required this.case_,
      required this.bags,
      required this.bloodGroup,
      required this.gender});

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final String patientName = widget.patient; // Assuming patient is a String
    final String contact = widget.contact;
    final String hospital = widget.hospital;
    final String residence = widget.residence;
    final String case_ = widget.case_; // Assuming case_ is a String
    final int bags = widget.bags; // Assuming bags is an int
    final String bloodGroup = widget.bloodGroup;
    final String gender = widget.gender;




    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
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
                  height: 10,
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
                const Text("Case:"),
                const SizedBox(
                  height: 5,
                ),
                 Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    case_,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Number of Bags:"),
                const SizedBox(
                  height: 5,
                ),
                 Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    bags.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Others:"),
                const SizedBox(
                  height: 5,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Needed Urgently',
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
