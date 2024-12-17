import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {

  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _HomeState();
}

class _HomeState extends State<Dashboard> {

  int _selectedIndex = 0;



  @override
  Widget build(BuildContext context) {

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

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
                },
              ),

              ListTile(
                leading: const Icon(Icons.inventory_2_sharp, color: Colors.white,),
                title: const Text('Inventory', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16),),
                selected: _selectedIndex == 1,
                onTap: () {
                  onItemTapped(1);
                  Navigator.pop(context);
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
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('4', style: TextStyle(fontSize: 50,color: Colors.white),),
                  subtitle: Text('Total Donors',style: TextStyle(fontSize: 20,color: Colors.white),),
                ),
            ]),
          ),
          Card(
            color: Colors.blue[900],
            child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('40', style: TextStyle(fontSize: 50,color: Colors.white),),
                    subtitle: Text('Total Blood Requests',style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ]),
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


