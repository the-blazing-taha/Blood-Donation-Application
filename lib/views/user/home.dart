import 'package:blood/views/user/details.dart';
import 'package:flutter/material.dart';

import '../../controllers/databaseController.dart';
import '../../models/requests.dart';

class Home extends StatefulWidget {

  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";


  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

    // Filter the list based on search query

    SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by name or location",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // List of donors
        ],
      ),
    );

    return Scaffold(
      body: FutureBuilder(
        future: databaseService.getRequest(),
        builder:  (context,snapshot){
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Request request = snapshot.data![index];
                return Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Keep this to minimize height
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red[900],
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(5.0), // Keep this padding small
                              child: Text(
                                request.bloodGroup,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        ListTile(
                          title: Text(request.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          leading: const CircleAvatar(
                            radius: 20,
                            child: Icon(
                              Icons.person,
                              size: 20,
                            ),
                          ),
                          trailing: Text("${request.bags} Bags | ${request.case_}" ,style:  const TextStyle(color: Colors.grey,fontSize: 15),),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.location_on_rounded), // Location icon
                              const SizedBox(width: 4), // Space between the icon and the text
                              Text(request.residence), // Subtitle text
                            ],

                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[900],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Details(
                                      patient: request.name,
                                      contact: request.contact,
                                      hospital: request.hospital,
                                      residence: request.residence,
                                      case_: request.case_,
                                      bags: request.bags,
                                      bloodGroup: request.bloodGroup,
                                      gender: request.gender,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Details', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 8), // Keep this small or remove if not needed
                          ],
                        ),
                      ],
                    ),
                  )
                );
              });},
      ),
    );
  }
}