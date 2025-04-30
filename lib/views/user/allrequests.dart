import 'package:blood/views/user/details.dart';
import 'package:blood/views/user/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'appbar.dart';
import 'chat_screen.dart';
import 'drawer.dart';

class AllRequests extends StatefulWidget {
  const AllRequests({super.key});

  @override
  State<AllRequests> createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {
  int selectedIndex = 0;
  final TextEditingController _searchControllerRequests = TextEditingController();

  String searchQueryRequests = '';

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    // Reset notification count when page opens
      notificationCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference requestsCollection = FirebaseFirestore.instance.collection('requests');
    final FirebaseAuth auth = FirebaseAuth.instance;


    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(

        appBar: CustomAppBar(title: 'All Requests'),
        drawer: SideDrawer(),


        body: SizedBox(
          child: Column(
            children: [

              const Text(
                'All Requests',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                                            : const SizedBox.shrink(), // Show nothing


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
                                                  details: data['details'],
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