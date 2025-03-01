import 'package:blood/views/user/details.dart';
import 'package:blood/views/user/my_donation_appeal.dart';
import 'package:blood/views/user/nearby_donors.dart';
import 'package:blood/views/user/nearby_requestors.dart';
import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/auth_controller.dart';
import 'donor_details.dart';
import 'my_requests.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();
  final TextEditingController _searchControllerDonors = TextEditingController();
  final TextEditingController _searchControllerRequests = TextEditingController();
  final FirebaseAuth _auth= FirebaseAuth.instance;

  String searchQueryDonors = '';
  String searchQueryRequests = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final CollectionReference requestsCollection = FirebaseFirestore.instance.collection('requests');
    final Stream<QuerySnapshot> donationCollection =
    FirebaseFirestore.instance.collection('donors').where('activity', isEqualTo: true)
        .snapshots();

    final user=FirebaseFirestore.instance.collection('users').doc(_auth.currentUser?.uid).get();
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(

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
                  child: Column(
                    children: [
                      const Text(
                        'Life Sync',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: user,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show a loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}'); // Handle errors
                          } else if (snapshot.hasData && snapshot.data!.exists) {
                            Map<String, dynamic>? userData = snapshot.data!.data();
                            String? profileImageUrl = userData?['profileImage'];
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 30, // Adjust size as needed
                                  backgroundColor: Colors.grey[300], // Fallback color
                                  child: ClipOval(
                                    child: profileImageUrl != null && profileImageUrl.isNotEmpty
                                        ? Image.network(
                                      profileImageUrl,
                                      width: 60, // 2 * radius
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                        : const Icon(Icons.person, size: 40), // Display default icon if no image
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Text('No user data found.');
                          }
                        },
                      ),
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: user,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show a loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}'); // Handle errors
                          } else if (snapshot.hasData && snapshot.data!.exists) {
                            Map<String, dynamic>? userData = snapshot.data!.data();
                            String? userName = userData?['fullName'];
                            return Column(
                              children: [
                                Text(userName as String, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily:'Pacifico' ),),
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
                    Icons.bloodtype_sharp,
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
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: const Text('Your Donation Registration',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  selected: _selectedIndex == 4,
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonationAppeal(),
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
                  selected: _selectedIndex == 5,
                  onTap: () {
                    _onItemTapped(5);
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
                  selected: _selectedIndex == 6,
                  onTap: () {
                    _onItemTapped(6);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.near_me,
                    color: Colors.white,
                  ),
                  title: const Text('Nearby donors',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  selected: _selectedIndex == 7,
                  onTap: () {
                    _onItemTapped(7);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NearbyDonors(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.near_me_outlined,
                    color: Colors.white,
                  ),
                  title: const Text('Nearby Requesters',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  selected: _selectedIndex == 8,
                  onTap: () {
                    _onItemTapped(8);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NearbyRequestors(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text('Log Out',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  selected: _selectedIndex == 9,
                  onTap: () {
                    _onItemTapped(9);
                    Navigator.pop(context);
                    _authController.signout();
                  },
                ),
                // Other ListTiles...
              ],
            ),
          ),
        ),


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
                                                  hospital: data['hospital'],
                                                  residence: data['residence'],
                                                  bloodGroup: data['bloodGroup'],
                                                  gender: data['gender'],
                                                  noOfDonations: data['donations_done'],
                                                  details: data['details'],
                                                  weight: data['weight'],
                                                  age: data['age'],
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

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchControllerRequests,
                  decoration: InputDecoration(
                    labelText: "Search by name or blood group",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQueryRequests = value.toLowerCase();
                    });
                  },
                ),
              ),

              const Text(
                'All Requests',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: requestsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }

                // Filter and sort requests based on search query and createdAt timestamp
                final requests = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toLowerCase();
                  final bloodGroup = (data['bloodGroup'] ?? '').toLowerCase();
                  return name.contains(searchQueryRequests) || bloodGroup.contains(searchQueryRequests);
                }).toList();

                // Sort by createdAt in descending order (newest first)
                requests.sort((a, b) {
                  final aTime = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
                  final bTime = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
                  return bTime.compareTo(aTime); // Descending order
                });
                if (requests.isEmpty) {
                  return const Center(child: Text('No matching requests found.'));
                }

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final data = request.data() as Map<String, dynamic>;

                    // Get createdAt timestamp
                    var createdAt = request['createdAt'] != null
                        ? (request['createdAt'] as Timestamp).toDate()
                        : DateTime.now();
                    var timeAgo = timeago.format(createdAt);

                    // Calculate elapsed time in seconds
                    int elapsedSeconds = DateTime.now().difference(createdAt).inSeconds;
                    double glowIntensity = (600 - elapsedSeconds) / 60; // Fade over 10 mins (600 sec)

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
                                color: Colors.red.withOpacity(glowIntensity / 10),
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
                                          : const Icon(Icons.person, size: 40),
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
                                        "${data['bags'] ?? 'N/A'} ml needed | ${data['case'] ?? 'N/A'}",
                                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
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
                                            builder: (context) => Details(
                                              patient: data['name'],
                                              contact: data['contact'],
                                              hospital: data['hospital'],
                                              residence: data['residence'],
                                              case_: data['case'],
                                              bags: data['bags'],
                                              bloodGroup: data['bloodGroup'],
                                              gender: data['gender'],
                                              email: data['email'],
                                              profileImage: data['profileUrl'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Details', style: TextStyle(color: Colors.white)),
                                    ),
                                    const SizedBox(width: 8),
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






