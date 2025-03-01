import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blood/models/inventory.dart';
import '../../controllers/databaseController.dart';
import 'dashboard.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  InventoryState createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  final DatabaseService _databaseService = DatabaseService.instance;
  late double progress; // Current progress value
  final PageStorageKey _key = const PageStorageKey('progressKey');
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

  void handleInventoryExpiration(BloodInventory inventory) {
    Timer(const Duration(seconds: 20), () {
      _databaseService.deleteInventory(inventory.id);
      setState(() {

      });
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
                    setState(() {
                      inventoryName = value;
                    });
                  },
                  controller: _inventoryNameController,
                  decoration: const InputDecoration(hintText: "Inventory Name"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                    setState(() {
                      hemoglobin = double.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                    });
                  },
                  controller: _hemoglobinController,
                  decoration: const InputDecoration(hintText: "Hemoglobin level (g/dL)"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  keyboardType: TextInputType.number,

                  onChanged: (value){
                    setState(() {
                      concentration = double.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                    });
                  },
                  controller: _concentrationController,
                  decoration: const InputDecoration(hintText: "Concentration (mL)"),
                ),
                const SizedBox(height: 4,),
                DropdownMenu<String>(
                  hintText: "Blood Group",
                  controller: _bloodGroupController,
                  inputDecorationTheme: InputDecorationTheme(
                    border: MaterialStateOutlineInputBorder.resolveWith(
                          (states) => states.contains(WidgetState.focused)
                          ?  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                          :  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 3,),
                          borderRadius:BorderRadius.all(Radius.circular(10.0))
                      ),

                    ),
                  ),
                  width: 325,
                  initialSelection: bloodTypes.first,
                  onSelected: (String? value) {
                    setState(() {
                      bloodGroup = value!;
                    });
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
                    border: MaterialStateOutlineInputBorder.resolveWith(
                          (states) => states.contains(WidgetState.focused)
                          ?  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                          :  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 3,),
                          borderRadius:BorderRadius.all(Radius.circular(10.0))
                      ),

                    ),
                  ),
                  width: 325,
                  initialSelection: genders.first,
                  onSelected: (String? value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                  dropdownMenuEntries: genders.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),

                DropdownMenu<String>(
                  hintText: "Rh Factor",
                  controller: _rhController,
                  inputDecorationTheme: InputDecorationTheme(
                    border: MaterialStateOutlineInputBorder.resolveWith(
                          (states) => states.contains(WidgetState.focused)
                          ?  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                          :  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 3,),
                          borderRadius:BorderRadius.all(Radius.circular(10.0))
                      ),

                    ),
                  ),
                  width: 325,
                  initialSelection: rhFactors.first,
                  onSelected: (String? value) {
                    setState(() {
                      rh = value!;
                    });
                  },
                  dropdownMenuEntries: rhFactors.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
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
                  inventoryNumber++;
                  _databaseService.addInventory(inventoryName,bloodGroup,hemoglobin,concentration,rh,gender,inventoryNumber);

                  Navigator.of(context).pop();
                  setState(() {

                  });
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





  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

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



        body: FutureBuilder(
          future: databaseService.getInventory(),
          builder:  (context,snapshot){
            return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  BloodInventory inventory = snapshot.data![index];
                  handleInventoryExpiration(inventory);
                  return Center(
                    child: Card(
                      color: Colors.grey[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(inventory.bloodgroup,style: const TextStyle(color: Colors.white),),
                              const SizedBox(width: 120,),
                              Text("${inventory.concentration}",style: const TextStyle(color: Colors.white),),
                            ],
                          ),
                          Text('Inventory Number: ${inventory.number} ',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                          Text('Haemoglobin: ${inventory.hemoglobin} g/dL',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                          Text('Concentration: ${inventory.concentration} mL',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                          Text('Blood Type: ${inventory.bloodgroup} ',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                          Text('Blood Rh: ${inventory.rh} ',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                          const SizedBox(height: 5,),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              disabledBackgroundColor:Colors.white,
                            ),
                            onPressed: () {
                              databaseService.deleteInventory(inventory.id);
                              setState(() {});
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.red[900])),
                          ),
                        ],
                      ),
                    ),


                  );
                });},
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          setState(() {
            addButton();
          });
        },child: const Icon(Icons.add),),
      ),
    );
  }
}