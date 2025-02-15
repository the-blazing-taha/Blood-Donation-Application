import 'package:blood/views/admin/dashboard.dart';
import 'package:blood/views/user/details.dart';
import 'package:flutter/material.dart';
import '../../controllers/databaseController.dart';
import '../../models/requests.dart';
import 'inventory.dart';

class BloodRequestsAdmin extends StatefulWidget {
  const BloodRequestsAdmin({super.key});


  @override
  State<BloodRequestsAdmin> createState() => _BloodRequestsAdminState();
}

class _BloodRequestsAdminState extends State<BloodRequestsAdmin> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _selectedIndex = 0;



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blood Request Control',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 10,
            padding: const EdgeInsets.all(1.0),
            onPressed: () {

            },
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
                Scaffold.of(context).openDrawer();  // This will now work correctly
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
                child: const Text('Drawer Header',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
              ),

              ListTile(
                leading: const Icon(Icons.home, color: Colors.white,),
                title: const Text('Dashboard',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16),),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.inventory_2_sharp, color: Colors.white,),
                title: const Text('Inventory', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16),),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Inventory(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),



      body: Column(
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

          Expanded(
            child: FutureBuilder<List<Request>>(
              future: databaseService.getRequest(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Request request = snapshot.data![index];
                    return Center(
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
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
                              title: Text(
                                request.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
                              ),
                              leading: const CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  Icons.person,
                                  size: 20,
                                ),
                              ),
                              trailing: Text(
                                "${request.bags} Bags | ${request.case_}",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.location_on_rounded),
                                  const SizedBox(width: 4),
                                  Text(request.residence),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    disabledBackgroundColor:Colors.white,
                                  ),
                                  onPressed: () {
                                    databaseService.deleteRequest(request.id);
                                    setState(() {});
                                  },
                                  child: Text('Delete', style: TextStyle(color: Colors.red[900])),
                                ),
                                const SizedBox(height: 5,),
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
                                          gender: request.gender, email: null,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Details',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
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
    );
  }
}
