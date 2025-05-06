import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'chat_screen.dart';
import 'donor_details.dart';
import 'drawer.dart';


class AllDonors extends StatefulWidget {
  const AllDonors({super.key});

  @override
  State<AllDonors> createState() => _AllDonorsState();
}

class _AllDonorsState extends State<AllDonors> {
  int selectedIndex = 0;
  final TextEditingController _searchControllerDonors = TextEditingController();
  String searchQueryDonors = '';

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> donationCollection =
    FirebaseFirestore.instance.collection('donors').where('activity', isEqualTo: true)
        .snapshots();
    final FirebaseAuth auth = FirebaseAuth.instance;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(

        appBar: AppBar(
          title: const Text(
            "Donors",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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

        drawer: SideDrawer(),


        body: SizedBox(
          child: Column(
            children: [

              const Text(
                'All Donors List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchControllerDonors,
                  decoration: InputDecoration(
                    labelText: "Search by name or blood group",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQueryDonors = value.toLowerCase();
                    });
                  },
                ),
              ),


              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: donationCollection,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No donations found.'));
                    }

                    // Filter and sort donors based on search query and createdAt timestamp
                    final donors = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name = (data['name'] ?? '').toLowerCase();
                      final bloodGroup = (data['bloodGroup'] ?? '').toLowerCase();
                      return name.contains(searchQueryDonors) || bloodGroup.contains(searchQueryDonors);
                    }).toList();

                    // Sort by createdAt in descending order (newest first)
                    donors.sort((a, b) {
                      final aTime = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
                      final bTime = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
                      return bTime.compareTo(aTime); // Descending order
                    });


                    if (donors.isEmpty) {
                      return const Center(child: Text('No matching donors found.'));
                    }

                    return ListView.builder(
                      itemCount: donors.length,
                      itemBuilder: (context, index) {
                        final donor = donors[index];
                        final data = donor.data() as Map<String, dynamic>;

                        // Get createdAt timestamp
                        var createdAt = donor['createdAt'] != null
                            ? (donor['createdAt'] as Timestamp).toDate()
                            : DateTime.now();
                        var timeAgo = timeago.format(createdAt);

                        // Calculate elapsed time in seconds
                        int elapsedSeconds = DateTime.now().difference(createdAt).inSeconds;
                        double glowIntensity = (300 - elapsedSeconds) / 30; // Fade over 5 mins (300 sec)

                        // Ensure glow doesn't go negative
                        glowIntensity = glowIntensity.clamp(0, 10);

                        return Center(
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                if (glowIntensity > 0) // Only apply glow if it's still active
                                  BoxShadow(
                                    color: Colors.yellow.withOpacity(glowIntensity / 10),
                                    blurRadius: glowIntensity,
                                    spreadRadius: glowIntensity / 2,
                                  ),
                              ],
                            ),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      timeAgo,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red[900],
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data['bloodGroup'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey[300],
                                        child: ClipOval(
                                          child: data['profileUrl'] != null &&
                                              data['profileUrl'].isNotEmpty
                                              ? Image.network(
                                            data['profileUrl'],
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          )
                                              : Icon(Icons.person, color: Colors.blue[900], size: 40),
                                        ),
                                      ),
                                      title: Text(
                                        data['name'] ?? 'Unknown',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on_rounded, size: 16),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  data['residence'] ?? 'Unknown',
                                                  style: const TextStyle(fontSize: 14),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${data['gender'] ?? 'N/A'} | ${data['donations_done'] ?? '0'} donations done",
                                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        data['userId'] != auth.currentUser!.uid
                                            ? IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatScreen(receiverId: data['userId'], receiverName: data['name']),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.message_outlined),
                                        )
                                            : const SizedBox.shrink(), //
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red[900],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DonorDetails(
                                                  patient: data['name'],
                                                  contact: data['contact'],
                                                  residence: data['residence'],
                                                  bloodGroup: data['bloodGroup'],
                                                  gender: data['gender'],
                                                  noOfDonations: data['donations_done'],
                                                  details: data['details'],
                                                  weight: data['weight'],
                                                  age: data['age'],
                                                  firstDonated: data['firstDonated'],
                                                  lastDonated: data['lastDonated'],
                                                  donationFrequency: data['donationFrequency'],
                                                  highestEducation: data['highestEducation'],
                                                  currentOccupation: data['currentOccupation'],
                                                  currentLivingArrg: data['currentLivingArrg'],
                                                  eligibilityTest: data['eligibilityTest'],
                                                  futureDonationWillingness: data['futureDonationWillingness'],
                                                  profileImage: data['profileUrl'],
                                                  email: data['email'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('Details', style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}