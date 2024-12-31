import 'package:blood/views/admin/blood_requests_admin.dart';
import 'package:blood/views/admin/inventory.dart';
import 'package:blood/views/user/donors_list.dart';
import 'package:blood/views/user/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/databaseController.dart';


class Dashboard extends StatefulWidget {

  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int _selectedIndex = 0;
  void onItemTapped(int index) {
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
            ],
          ),
        ),
      ),





      body:  Column(
        children: [
          Card(
            color: Colors.red[900],
            child: InkWell(
              onTap: () {
                // Handle card tap event (e.g., navigate to a donors list screen)
                Get.to(const DonorList());
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FutureBuilder<int?>(
                    future: databaseService.noOfDonors(), // Call the async function
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While the future is resolving, show a loading indicator or placeholder text
                        return const ListTile(
                          title: Text("Loading...", style: TextStyle(fontSize: 50, color: Colors.white)),
                          subtitle: Text('Total Donors', style: TextStyle(fontSize: 20, color: Colors.white)),
                        );
                      } else if (snapshot.hasError) {
                        // Handle errors gracefully
                        return const ListTile(
                          title: Text("Error", style: TextStyle(fontSize: 50, color: Colors.white)),
                          subtitle: Text('Could not fetch requests', style: TextStyle(fontSize: 20, color: Colors.white)),
                        );
                      } else {
                        // Display the result when the future completes
                        final count = snapshot.data ?? 0;
                        return ListTile(
                          title: Text(count.toString(), style: const TextStyle(fontSize: 50, color: Colors.white)),
                          subtitle: const Text('Total Donors', style: TextStyle(fontSize: 20, color: Colors.white)),
                        );
                      }
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
            Get.to(const BloodRequestsAdmin());
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FutureBuilder<int?>(
                future: databaseService.noOfRequests(), // Call the async function
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the future is resolving, show a loading indicator or placeholder text
                    return const ListTile(
                      title: Text("Loading...", style: TextStyle(fontSize: 50, color: Colors.white)),
                      subtitle: Text('Total Blood Requests', style: TextStyle(fontSize: 20, color: Colors.white)),
                    );
                  } else if (snapshot.hasError) {
                    // Handle errors gracefully
                    return const ListTile(
                      title: Text("Error", style: TextStyle(fontSize: 50, color: Colors.white)),
                      subtitle: Text('Could not fetch requests', style: TextStyle(fontSize: 20, color: Colors.white)),
                    );
                  } else {
                    // Display the result when the future completes
                    final count = snapshot.data ?? 0;
                    return ListTile(
                      title: Text(count.toString(), style: const TextStyle(fontSize: 50, color: Colors.white)),
                      subtitle: const Text('Total Blood Requests', style: TextStyle(fontSize: 20, color: Colors.white)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),


      Card(
            color: Colors.yellow[900],
            child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('28', style: TextStyle(fontSize: 50,color: Colors.white),),
                    subtitle: Text('Total Appointments Booked',style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ]),
          ),
          Card(
            color: Colors.green[600],
            child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('59', style: TextStyle(fontSize: 50,color: Colors.white),),
                    subtitle: Text('Active Donors',style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ]),
          ),
          Card(
            color: Colors.brown[400],
            child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('100', style: TextStyle(fontSize: 50,color: Colors.white),),
                    subtitle: Text('Total Accounts',style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ]),
          ),
        ],
      ),




    );
  }
}


