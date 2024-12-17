import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // First Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: CupertinoColors.systemYellow, width: 10),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(Icons.person_outline_outlined, size: 60, color: CupertinoColors.systemYellow),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Profile",
                        style: TextStyle(
                          color: CupertinoColors.systemYellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange, width: 10),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Icon(Icons.list, size: 60, color: Colors.orange[900]),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Requests",
                        style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red[900]!, width: 10),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Icon(Icons.bloodtype_outlined, size: 60, color: Colors.red[900]),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Donations",
                        style: TextStyle(
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Second Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blue[900]!, width: 10),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Icon(Icons.star_border_outlined, size: 60, color: Colors.blue[900]),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Rate App.",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: CupertinoColors.activeGreen, width: 10),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(Icons.logout, size: 60, color: CupertinoColors.activeGreen),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Logout",
                        style: TextStyle(
                          color: CupertinoColors.activeGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.orange[900]!, width: 10),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Icon(Icons.settings_outlined, size: 60, color: Colors.orange[900]),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Settings",
                        style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
