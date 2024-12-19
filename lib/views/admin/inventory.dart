import 'package:flutter/material.dart';
import 'dart:async';

import 'dashboard.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  InventoryState createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  late double progress; // Current progress value
  Timer? _timer;
  // final int durationInSeconds=3024000; // Total time for the timer
  final int durationInSeconds=10; // Total time for the timer
  final PageStorageKey _key = const PageStorageKey('progressKey');
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    progress = 1.0; // Start with full progress
    startTimer();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        progress -= 1 / (durationInSeconds * 10); // Decrease progress
        if (progress <= 0) {
          progress = 0;
          _timer?.cancel(); // Stop the timer when progress reaches 0
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
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



      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: LinearProgressIndicator(
                key: _key,
                value: progress, // Bind progress to the LinearProgressIndicator
                minHeight: 20, // Set the height of the progress bar
                color: Colors.red, // Progress bar color
                backgroundColor: Colors.grey[300], // Background color
              ),
            ),
          ],
        ),
    );
  }
}





