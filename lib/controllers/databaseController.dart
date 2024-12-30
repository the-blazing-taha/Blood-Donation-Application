import 'package:blood/models/donations.dart';
import 'package:blood/models/requests.dart';
import 'package:blood/models/inventory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }
  final String requestsTableName = "requests";
  final String _requestIdColumnName = "_id";
  final String _patientNameColumnName = "name";
  final String _contactColumnName = "contact";
  final String _hospitalNameColumn= "hospital";
  final String _residenceNameColumn = "residence";
  final String _caseNameColumn = "case_";
  final String _bagsNumberColumn = "bags";
  final String _bloodGroupColumn = "bloodGroup";
  final String _genderTypeColumn = "gender";


  final String donationsTableName = "donations";
  final String _donationIdColumnName = "_id";
  final String _donationsNumberColumn = "donations";

  final String _inventoryTableName = "inventory";
  final String _inventoryIdColumnName = "_id";
  final String _inventoryBloodTypeColumnName = "bloodtype";
  final String _inventoryBloodConcentrationColumnName = "concentration";
  final String _inventoryBloodRhFactorColumn = "rh";
  final String _inventoryBloodHaemoglobinlevel = "haemoglobin";
  final String _inventoryGenderColumnName = "gender";
  final String _inventoryNameColumnName = "name";
  final String _inventoryNumberColumnName = "number";


  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "bloodsystem.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $requestsTableName (
            $_requestIdColumnName INTEGER PRIMARY KEY,
            $_patientNameColumnName TEXT NOT NULL,
            $_contactColumnName TEXT NOT NULL,
            $_hospitalNameColumn TEXT NOT NULL,
            $_residenceNameColumn TEXT NOT NULL,
            $_caseNameColumn TEXT NOT NULL,
            $_bagsNumberColumn INTEGER NOT NULL,
            $_bloodGroupColumn TEXT NOT NULL,
            $_genderTypeColumn TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE $donationsTableName (
            $_donationIdColumnName INTEGER PRIMARY KEY,
            $_patientNameColumnName TEXT NOT NULL,
            $_contactColumnName TEXT NOT NULL,
            $_hospitalNameColumn TEXT NOT NULL,
            $_residenceNameColumn TEXT NOT NULL,
            $_donationsNumberColumn INTEGER NOT NULL,
            $_bloodGroupColumn TEXT NOT NULL,
            $_genderTypeColumn TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE $_inventoryTableName (
            $_inventoryIdColumnName INTEGER PRIMARY KEY,
            $_inventoryNameColumnName TEXT NOT NULL,
            $_inventoryBloodTypeColumnName TEXT NOT NULL,
            $_inventoryBloodConcentrationColumnName DOUBLE NOT NULL,
            $_inventoryBloodHaemoglobinlevel DOUBLE NOT NULL,
            $_inventoryGenderColumnName TEXT NOT NULL,
            $_inventoryBloodRhFactorColumn TEXT NOT NULL,
            $_inventoryNumberColumnName INTEGER NOT NULL
          )
        ''');
      },
    );
    return database;
  }

  Future<void> addRequest(String name, String contact, String hospital, String residence, String case_, int bags, String bloodGroup,String gender) async {
    final db = await database;
    await db.insert(requestsTableName, {
      _patientNameColumnName: name,
      _contactColumnName: contact,
      _hospitalNameColumn: hospital,
      _residenceNameColumn: residence,
      _caseNameColumn: case_,
      _bagsNumberColumn: bags,
      _bloodGroupColumn: bloodGroup,
      _genderTypeColumn: gender
    });
  }

  Future<void> addDonation(String name, String contact, String hospital, String residence, int donationNumber, String bloodGroup,String gender) async {
    final db = await database;
    await db.insert(donationsTableName, {
      _patientNameColumnName: name,
      _contactColumnName: contact,
      _hospitalNameColumn: hospital,
      _residenceNameColumn: residence,
      _donationsNumberColumn: donationNumber,
      _bloodGroupColumn: bloodGroup,
      _genderTypeColumn: gender
    });
  }



  Future<List<Request>> getRequest() async {
    final db = await database;
    final data = await db.query(requestsTableName);
    List<Request> requests = data
        .map((e) => Request(
      id: e[_requestIdColumnName] as int,
      name: e[_patientNameColumnName] as String,
      contact: e[_contactColumnName] as String,
      hospital: e[_hospitalNameColumn] as String,
      residence: e[_residenceNameColumn] as String,
      case_: e[_residenceNameColumn] as String,
      bags: e[_bagsNumberColumn] as int,
      bloodGroup: e[_bloodGroupColumn] as String,
        gender: e[_genderTypeColumn] as String
    ))
        .toList();
    return requests;
  }

  Future<List<Donation>> getDonation() async {
    final db = await database;
    final data = await db.query(donationsTableName);
    List<Donation> donations = data
        .map((e) => Donation(
        id: e[_requestIdColumnName] as int,
        name: e[_patientNameColumnName] as String,
        contact: e[_contactColumnName] as String,
        hospital: e[_hospitalNameColumn] as String,
        residence: e[_residenceNameColumn] as String,
        bloodGroup: e[_bloodGroupColumn] as String,
        gender: e[_genderTypeColumn] as String,
        donationsDone: e[_donationsNumberColumn] as int,
    ))
        .toList();
    return donations;
  }

  // Future<void> updateRequest(int id, String name, String contact, String hospital, String residence, String case_, int bags, String bloodGroup,String gender) async {
  //   final db = await database;
  //   await db.update(
  //     requestsTableName,
  //     {
  //       _patientNameColumnName: name,
  //       _contactColumnName: contact,
  //       _hospitalNameColumn: hospital,
  //       _residenceNameColumn: residence,
  //       _bagsNumberColumn:bags,
  //       _bloodGroupColumn:bloodGroup,
  //       _genderTypeColumn: gender,
  //     },
  //     where: '$_requestIdColumnName = ?', // Use the correct column name
  //     whereArgs: [id,],
  //   );
  // }

  Future<void> deleteRequest(int id) async {
    final db = await database;
    try {
      await db
          .delete(requestsTableName, where: '$_requestIdColumnName = ?', whereArgs: [
        id,
      ]);
    }
    catch(e){
      print("ERROR IN DELETING REQUEST: $e");
    }
  }

  Future<void> deleteDonation(int id) async {
    final db = await database;
    try {
      await db
          .delete(donationsTableName, where: '$_donationIdColumnName = ?', whereArgs: [
        id,
      ]);
    }
    catch(e){
      print("ERROR IN DELETING DONATION APPEAL: $e");
    }
  }



  Future<void> deleteInventory(int id) async {
    final db = await database;
    try {
      await db
          .delete(_inventoryTableName, where: '$_inventoryIdColumnName = ?', whereArgs: [
        id,
      ]);
    }
    catch(e){
      print("ERROR IN DELETING INVENTORY: $e");
    }
  }

  Future<int?> noOfRequests() async {
    final db = await database; // Ensure `database` is initialized
    try {
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $requestsTableName');
      return Sqflite.firstIntValue(result) ?? 0; // Extract the count
    } catch (e) {
      print("Error in noOfRequests(): $e");
      return null; // Return null if an exception occurs
    }
  }

  Future<int?> noOfDonors() async {
    final db = await database; // Ensure `database` is initialized
    try {
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $donationsTableName');
      return Sqflite.firstIntValue(result) ?? 0; // Extract the count
    } catch (e) {
      print("Error in noOfRequests(): $e");
      return null; // Return null if an exception occurs
    }
  }

  Future<void> addInventory(String name,String bloodGroup, double hemoglobin, double concentration, String rh, String gender, int number) async {
    final db = await database;
    await db.insert(_inventoryTableName, {
      _inventoryNameColumnName: name,
      _inventoryNumberColumnName: number,
      _inventoryBloodTypeColumnName: bloodGroup,
      _inventoryBloodHaemoglobinlevel: hemoglobin,
      _inventoryBloodConcentrationColumnName: concentration,
      _inventoryBloodRhFactorColumn: rh,
      _inventoryGenderColumnName: gender,
    });
  }

  Future<List<BloodInventory>> getInventory() async {
    final db = await database;
    final data = await db.query(_inventoryTableName);
    List<BloodInventory> inventory = data
        .map((e) => BloodInventory(
        id: e[_inventoryIdColumnName] as int,
        name: e[_inventoryNameColumnName] as String,
        hemoglobin: e[_inventoryBloodHaemoglobinlevel] as double,
        concentration: e[_inventoryBloodConcentrationColumnName] as double,
        bloodgroup: e[_inventoryBloodTypeColumnName] as String,
        rh: e[_inventoryBloodRhFactorColumn] as String,
        gender: e[_inventoryGenderColumnName] as String,
        number: e[_inventoryNumberColumnName] as int,
    ))
        .toList();
    return inventory;
  }
}





