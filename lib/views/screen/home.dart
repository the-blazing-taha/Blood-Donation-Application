import 'package:blood/views/screen/details.dart';
import 'package:flutter/material.dart';

import '../../controllers/databaseController.dart';
import '../../models/requests.dart';

class Home extends StatefulWidget {
  String bloodGroup = '';
  String gender = '';
  int bags=0;
  String hospital='';
  String patient="";
  String residence="";
  String case_="";
  String contact="";

  Home({super.key,
    this.bloodGroup = '',
    this.gender = '',
    this.bags = 0,
    this.hospital = '',
    this.patient = '',
    this.residence = '',
    this.case_ = '',
    this.contact = '',
  });


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Example list of donors (You can fetch this from a backend or a local source)
  // final List<Map<String, String>> _donors = [];



  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    // Filter the list based on search query
    return Scaffold(
      body: SizedBox(
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
            Expanded(
              child:FutureBuilder(
                future: _databaseService.getRequest(),
                builder:  (context,snapshot){
                  return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Request request_ = snapshot.data![index];
                        return Center(
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.album),
                                  title: Text(request_.name,),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.album),
                                  title: Text(request_.residence,),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('Details'),
                                      onPressed: () {

                                      },
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
