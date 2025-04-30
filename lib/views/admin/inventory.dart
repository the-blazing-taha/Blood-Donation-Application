import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import '../../controllers/fireStoreDatabaseController.dart';
import 'dashboard.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  InventoryState createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  final fireStoreDatabaseController _firebaseDatabase = fireStoreDatabaseController();

  late double progress; // Current progress value
  int _selectedIndex = 0;
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _hemoglobinController = TextEditingController();
  final TextEditingController _concentrationController = TextEditingController();
  final TextEditingController _inventoryNameController = TextEditingController();
  final TextEditingController _rhController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  static List<String> bloodTypes = <String>['None','A+', 'B+', 'AB+', 'O+','A-', 'B-', 'AB-', 'O-'];
  static List<String> rhFactors = <String>['None','+','-'];
  static List<String> genders = <String>['None','Male','Female'];


  late String bloodGroup;
  late double hemoglobin;
  late String inventoryName;
  late double concentration;
  late String gender;
  late String rh;
  static int inventoryNumber = 0;


  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void handleInventoryExpiration(String id) {
    Timer(const Duration(seconds: 20), () {
      _firebaseDatabase.removeInventoryColor(id);
    });
  }



  void addButton() {
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Add Request'),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value){
                      inventoryName = value;
                  },
                  controller: _inventoryNameController,
                  decoration: const InputDecoration(hintText: "Inventory Name"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                      hemoglobin = double.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                  },
                  controller: _hemoglobinController,
                  decoration: const InputDecoration(hintText: "Hemoglobin level (g/dL)"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  keyboardType: TextInputType.number,

                  onChanged: (value){
                      concentration = double.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                  },
                  controller: _concentrationController,
                  decoration: const InputDecoration(hintText: "Concentration (mL)"),
                ),
                const SizedBox(height: 4,),
                DropdownMenu<String>(
                  hintText: "Blood Group",
                  controller: _bloodGroupController,
                  inputDecorationTheme: InputDecorationTheme(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 3,),
                        borderRadius:BorderRadius.all(Radius.circular(10.0))
                    ),
                  ),
                  width: 325,
                  initialSelection: bloodTypes.first,
                  onSelected: (String? value) {
                      bloodGroup = value!;
                  },
                  dropdownMenuEntries: bloodTypes.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),
                DropdownMenu<String>(
                  hintText: "Gender",
                  controller: _genderController,
                  inputDecorationTheme: InputDecorationTheme(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red,width: 3,),
                        borderRadius:BorderRadius.all(Radius.circular(10.0))
                    ),
                  ),
                  width: 325,
                  initialSelection: genders.first,
                  onSelected: (String? value) {
                      gender = value!;
                  },
                  dropdownMenuEntries: genders.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),

                // DropdownMenu<String>(
                //   hintText: "Rh Factor",
                //   controller: _rhController,
                //   inputDecorationTheme: InputDecorationTheme(
                //     border: WidgetStateInputBorder.resolveWith(
                //           (states) => states.contains(WidgetState.focused)
                //           ?  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                //           :  const OutlineInputBorder(
                //           borderSide: BorderSide(color: Colors.red,width: 3,),
                //           borderRadius:BorderRadius.all(Radius.circular(10.0))
                //       ),
                //
                //     ),
                //   ),
                //   width: 325,
                //   initialSelection: rhFactors.first,
                //   onSelected: (String? value) {
                //       rh = value!;
                //   },
                //   dropdownMenuEntries: rhFactors.map<DropdownMenuEntry<String>>((String value) {
                //     return DropdownMenuEntry<String>(value: value, label: value);
                //   }).toList(),
                // ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _bloodGroupController.clear();
                  _genderController.clear();
                  _concentrationController.clear();
                  _hemoglobinController.clear();
                  _inventoryNameController.clear();
                  _rhController.clear();
                  _firebaseDatabase.addInventory(inventoryName, bloodGroup, inventoryNumber, concentration, gender, hemoglobin);

                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('Add Inventory'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String searchQueryRequests = '';
  final TextEditingController _searchControllerRequests = TextEditingController();




  @override
  Widget build(BuildContext context) {
    final CollectionReference inventoryCollection = FirebaseFirestore.instance.collection('inventory');

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
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



        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🩸 Blood Bag Inventory',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.redAccent),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchControllerRequests,
                decoration: InputDecoration(
                  labelText: "Search by name, blood group or expiration status",
                  prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQueryRequests = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 15),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: inventoryCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No inventory found.'));
                    }

                    final inventories = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name = (data['name'] ?? '').toLowerCase();
                      final bloodGroup = (data['bloodGroup'] ?? '').toLowerCase();
                      final expiration = (data['isExpired'] ?? '');

                      return name.contains(searchQueryRequests) || bloodGroup.contains(searchQueryRequests) || expiration.contains(searchQueryRequests);
                    }).toList();

                    inventories.sort((a, b) {
                      final aTime = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
                      final bTime = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
                      return bTime.compareTo(aTime);
                    });

                    if (inventories.isEmpty) {
                      return const Center(child: Text('No matching inventories found.'));
                    }

                    return ListView.builder(
                      itemCount: inventories.length,
                      itemBuilder: (context, index) {
                        final request = inventories[index];
                        final data = request.data() as Map<String, dynamic>;

                        var createdAt = request['createdAt'] != null
                            ? (request['createdAt'] as Timestamp).toDate()
                            : DateTime.now();
                        var timeAgo = timeago.format(createdAt);
                          handleInventoryExpiration(data['inventoryId']);
                        return Card(
                          color: data['isExpired'] == true ? Colors.grey[500] : Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    timeAgo,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildInfoChip('Blood Type', data['bloodGroup'] ?? 'N/A', Colors.redAccent),
                                    _buildInfoChip('Hemoglobin', '${data['haemoglobin'] ?? 'N/A'} g/dL', Colors.blue),
                                    _buildInfoChip('Volume', '${data['concentration'] ?? 'N/A'} mL', Colors.green),
                                    _buildInfoChip('Expiration Status', '${data['isExpired'] ?? 'N/A'}', Colors.yellow[800]!),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    label: const Text(
                                      'Delete',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    onPressed: () {
                                        _firebaseDatabase.deleteInventory(data['inventoryId']);
                                      setState(() {});
                                    },
                                  ),
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
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          setState(() {
            addButton();
          });
        },child: const Icon(Icons.add),),
      ),
    );

  }
  Widget _buildInfoChip(String label, String value, Color color) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      label: Text(
        '$label: $value',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}