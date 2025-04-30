import 'package:blood/views/admin/inventory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';


class Dashboard extends StatefulWidget {

  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthController _authController = AuthController();
  int _selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
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
                  onItemTapped(0);
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
                  onItemTapped(1);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Inventory(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white,),
                title: const Text('Log out', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16),),
                selected: _selectedIndex == 2,
                onTap: () {
                  onItemTapped(2);
                  Navigator.pop(context);
                  _authController.signout();
                },
              ),
            ],
          ),
        ),
      ),





      body:  SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Card(
              color: Colors.red[900],
              child: InkWell(
                onTap: () {
                  // Handle card tap event (e.g., navigate to a donors list screen)
                  // Get.to(const BloodAppealAdmin());
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('donors').snapshots(), // Real-time listener
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            title: Text("Loading...", style: TextStyle(fontSize: 50, color: Colors.white)),
                            subtitle: Text('Total Blood Donors', style: TextStyle(fontSize: 20, color: Colors.white)),
                          );
                        } else if (snapshot.hasError) {
                          return const ListTile(
                            title: Text("Error", style: TextStyle(fontSize: 50, color: Colors.white)),
                            subtitle: Text('Could not fetch donors', style: TextStyle(fontSize: 20, color: Colors.white)),
                          );
                        }

                        int count = snapshot.data?.docs.length ?? 0; // Count documents manually

                        return ListTile(
                          title: Text(count.toString(), style: const TextStyle(fontSize: 50, color: Colors.white)),
                          subtitle: const Text('Total Blood donors', style: TextStyle(fontSize: 20, color: Colors.white)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        Card(
          color: Colors.blue[900],
          child: InkWell(
            onTap: () {
              // Handle card tap event (e.g., navigate to a donors list screen)
              // Get.to(const BloodRequestsAdmin());
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('requests').snapshots(), // Real-time listener
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        title: Text("Loading...", style: TextStyle(fontSize: 50, color: Colors.white)),
                        subtitle: Text('Total Blood Requests', style: TextStyle(fontSize: 20, color: Colors.white)),
                      );
                    } else if (snapshot.hasError) {
                      return const ListTile(
                        title: Text("Error", style: TextStyle(fontSize: 50, color: Colors.white)),
                        subtitle: Text('Could not fetch requests', style: TextStyle(fontSize: 20, color: Colors.white)),
                      );
                    }

                    int count = snapshot.data?.docs.length ?? 0; // Count documents manually

                    return ListTile(
                      title: Text(count.toString(), style: const TextStyle(fontSize: 50, color: Colors.white)),
                      subtitle: const Text('Total Blood Requests', style: TextStyle(fontSize: 20, color: Colors.white)),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
            Card(
              color: Colors.green,
              child: InkWell(
                onTap: () {
                  // Handle card tap event (e.g., navigate to a donors list screen)
                  // Get.to(const BloodRequestsAdmin());
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('donors').where('activity', isEqualTo: true).snapshots(), // Real-time listener
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            title: Text("Loading...", style: TextStyle(fontSize: 50, color: Colors.white)),
                            subtitle: Text('Total Blood Donors', style: TextStyle(fontSize: 20, color: Colors.white)),
                          );
                        } else if (snapshot.hasError) {
                          return const ListTile(
                            title: Text("Error", style: TextStyle(fontSize: 50, color: Colors.white)),
                            subtitle: Text('Could not fetch donors', style: TextStyle(fontSize: 20, color: Colors.white)),
                          );
                        }

                        int count = snapshot.data?.docs.length ?? 0; // Count documents manually

                        return ListTile(
                          title: Text(count.toString(), style: const TextStyle(fontSize: 50, color: Colors.white)),
                          subtitle: const Text('Total Active Donors', style: TextStyle(fontSize: 20, color: Colors.white)),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
            Card(
              color: Colors.yellow[700],
              child: InkWell(
                onTap: () {
                  // Handle card tap event (e.g., navigate to a donors list screen)
                  // Get.to(const BloodRequestsAdmin());
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('users').snapshots(), // Real-time listener
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            title: Text("Loading...", style: TextStyle(fontSize: 50, color: Colors.white)),
                            subtitle: Text('Total Users', style: TextStyle(fontSize: 20, color: Colors.white)),
                          );
                        } else if (snapshot.hasError) {
                          return const ListTile(
                            title: Text("Error", style: TextStyle(fontSize: 50, color: Colors.white)),
                            subtitle: Text('Could not fetch users', style: TextStyle(fontSize: 20, color: Colors.white)),
                          );
                        }

                        int count = snapshot.data?.docs.length ?? 0; // Count documents manually

                        return ListTile(
                          title: Text(count.toString(), style: const TextStyle(fontSize: 50, color: Colors.white)),
                          subtitle: const Text('Total Accounts', style: TextStyle(fontSize: 20, color: Colors.white)),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),




    );
  }
}


