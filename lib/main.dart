import 'dart:io';
import 'package:blood/views/screen/home.dart';
import 'package:blood/views/screen/profile.dart';
import 'package:blood/views/screen/registerdonor.dart';
import 'package:blood/views/screen/request_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


void setLocale() {
  FirebaseAuth.instance
      .setLanguageCode('en'); // Set your desired locale, e.g., 'en' for English
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyA5deSHAnABXp7rZQtbCtk0aTO-A-XE9Ts',
              appId: '1:265277944690:android:65dcc9005385a7293423eb',
              messagingSenderId: '265277944690',
              projectId: 'blood-donors-and-acceptors',
              storageBucket: 'gs://blood-donors-and-acceptors.appspot.com'),
        )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: NavigationExample(),
      home: NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});


  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  String title = 'Home';
  String authChoice = '';
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  static List<String> list = <String>['Anemia', 'Cancer', 'Hemophilia', 'Sickle cell disease'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
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
                title: const Text('Home',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16),),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.bloodtype_sharp, color: Colors.white,),
                title: const Text('Your Requests',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16),),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.join_inner,color: Colors.white,),
                title: const Text('Matches',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16)),
                selected: _selectedIndex == 2,

                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings,color: Colors.white,),
                title: const Text('Settings',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16)),
                selected: _selectedIndex == 2,

                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          setState(() {
            if (currentPageIndex == 0) {
              title = "Home";
            } else if (currentPageIndex == 1) {
              title = "Request Form";
            } else if (currentPageIndex == 2) {
              title = "Register Donor";
            } else if (currentPageIndex == 3) {
              title = "Profile";
            }
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home),
            icon: Icon(
              Icons.home_outlined,
              color: Colors.red[900],
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.red[900],
            ),
            label: 'Add Request',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.inventory,
              color: Colors.red[900],
            ),
            label: 'Register Donor',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Colors.red[900],
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
          Home(),
          const RequestForm(),
          RequestDonor(),
          // Profile(),
        ][currentPageIndex],

    );
  }
}