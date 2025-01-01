import 'package:blood/views/user/profile.dart';
import 'package:blood/views/user/registerdonor.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:flutter/material.dart';
import '../../controllers/databaseController.dart';
import '../../models/requests.dart';
import 'details.dart';
import 'donors_list.dart';
import 'home.dart';




class Requests extends StatefulWidget {

  const Requests({super.key});
  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bagsController = TextEditingController();
  final TextEditingController _caseController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  static List<String> bloodTypes = <String>['None','A+', 'B+', 'AB+', 'O+','A-', 'B-', 'AB-', 'O-'];
  static List<String> donationCases = <String>['None','Anemia','Hemophilia','Thalassemia','Operation','Accident'];
  static List<String> genders = <String>['None','Male','Female'];
   String bloodGroup='';
   String gender='' ;
   int bags=-1;
   String hospital='';
   String patient='';
   String residence='';
   String donationCase='';
   String contact='';
   String details='';

  void updateButton(int id) {
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Update Request'),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value){
                    setState(() {
                      patient=value;
                    });
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: "Patient Name"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      residence=value;
                    });
                  },
                  controller: _locationController,
                  decoration: const InputDecoration(hintText: "Location"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                    setState(() {
                      bags = int.tryParse(value) ?? 0; // If parsing fails, it will default to 0
                    });
                  },
                  controller: _bagsController,
                  decoration: const InputDecoration(hintText: "Bags"),
                ),

                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      hospital=value;
                    });
                  },
                  controller: _hospitalController,
                  decoration: const InputDecoration(hintText: "Hospital"),
                ),
                const SizedBox(height: 4,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      details=value;
                    });
                  },
                  controller: _detailsController,
                  decoration: const InputDecoration(hintText: "Details"),
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
                      bloodGroup=value!;
                    });
                  },
                  dropdownMenuEntries: bloodTypes.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),
                DropdownMenu<String>(
                  hintText: "Donation Case",
                  controller: _caseController,
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
                  initialSelection: donationCases.first,
                  onSelected: (String? value) {
                    setState(() {
                      donationCase=value!;
                    });
                  },
                  dropdownMenuEntries: donationCases.map<DropdownMenuEntry<String>>((String value) {
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
                        gender=value!;
                    });
                  },
                  dropdownMenuEntries: genders.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 4,),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if(patient!=''){
                    _databaseService.updateRequest(id: id, name: patient);
                    Navigator.of(context).pop();
                  }
                  if(bloodGroup!=''){
                    _databaseService.updateRequest(id: id, bloodGroup: bloodGroup);
                    Navigator.of(context).pop();
                  }
                  if(gender!=''){
                    _databaseService.updateRequest(id: id, gender: gender);
                    Navigator.of(context).pop();
                  }
                  if(residence!=''){
                    _databaseService.updateRequest(id: id, residence: residence);
                    Navigator.of(context).pop();
                  }
                  if(contact!=''){
                    _databaseService.updateRequest(id: id, contact: contact);
                    Navigator.of(context).pop();
                  }
                  if(donationCase!=''){
                    _databaseService.updateRequest(id: id, case_: donationCase);
                    Navigator.of(context).pop();
                  }
                  if(details!=''){
                    _databaseService.updateRequest(id: id, details: details);
                    Navigator.of(context).pop();
                  }
                  setState(() {
                    updateButton(id);
                    _genderController.clear();
                    _nameController.clear();
                    _bloodGroupController.clear();
                    _locationController.clear();
                    _detailsController.clear();
                    _bagsController.clear();
                    _genderController.clear();
                    _caseController.clear();
                    _hospitalController.clear();
                  });
                },

                child: const Text('Update Request'),
              ),
              TextButton(
                onPressed: () {
                  _genderController.clear();
                  _nameController.clear();
                  _bloodGroupController.clear();
                  _locationController.clear();
                  _detailsController.clear();
                  _bagsController.clear();
                  _genderController.clear();
                  _caseController.clear();
                  _hospitalController.clear();

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

    // Filter the list based on search query

    SizedBox(
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
        ],
      ),
    );

    int selectedIndex = 0;

    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Request for Blood",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 10,
            padding: const EdgeInsets.all(1.0),
            onPressed: () {},
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
                Scaffold.of(context).openDrawer();
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
                child: const Text(
                  'Life Sync',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                selected: selectedIndex == 0,
                onTap: () {
                  onItemTapped(0);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.bloodtype_sharp,
                  color: Colors.white,
                ),
                title: const Text(
                  'Your Requests',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                selected: selectedIndex == 1,
                onTap: () {
                  onItemTapped(1);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Requests(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                title: const Text(
                  'All Donors',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                selected: selectedIndex == 2,
                onTap: () {
                  onItemTapped(2);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DonorList(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: const Text('Register as Donor',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: selectedIndex == 3,
                onTap: () {
                  onItemTapped(3);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestDonor(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.request_page,
                  color: Colors.white,
                ),
                title: const Text('Add Blood Request',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: selectedIndex == 4,
                onTap: () {
                  onItemTapped(4);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestForm(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.request_page,
                  color: Colors.white,
                ),
                title: const Text('Profile',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                selected: selectedIndex == 5,
                onTap: () {
                  onItemTapped(5);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
              ),
              // Other ListTiles...
            ],
          ),
        ),
      ),




      body: FutureBuilder(
        future: databaseService.getRequest(),
        builder:  (context,snapshot){
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Request request = snapshot.data![index];
                return Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Keep this to minimize height
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[900],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(5.0), // Keep this padding small
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
                            title: Text(request.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            leading: const CircleAvatar(
                              radius: 20,
                              child: Icon(
                                Icons.person,
                                size: 20,
                              ),
                            ),
                            trailing: Text("${request.bags} Bags}" ,style:  const TextStyle(color: Colors.grey,fontSize: 15),),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.location_on_rounded), // Location icon
                                const SizedBox(width: 4), // Space between the icon and the text
                                Text(request.residence), // Subtitle text
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
                                  updateButton(request.id);
                                  setState(() {});
                                },
                                child: Text('Update', style: TextStyle(color: Colors.red[900])),
                              ),
                              const SizedBox(width: 4,),
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
                              const SizedBox(width: 4,),
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
                                        gender: request.gender,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Details', style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 8), // Keep this small or remove if not needed
                            ],
                          ),
                        ],
                      ),
                    )
                );
              });},
      ),
    );
  }
}


