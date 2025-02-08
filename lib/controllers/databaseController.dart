import 'package:blood/models/donations.dart';
import 'package:blood/models/requests.dart';
import 'package:blood/models/inventory.dart';
import 'package:flutter/rendering.dart';
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
  final String _hospitalNameColumn = "hospital";
  final String _residenceNameColumn = "residence";
  final String _caseNameColumn = "case_";
  final String _bagsNumberColumn = "bags";
  final String _bloodGroupColumn = "bloodGroup";
  final String _genderTypeColumn = "gender";
  final String _detailsColumnName= "details";




  final String donationsTableName = "donations";
  final String _donationIdColumnName = "_id";
  final String _donationsNumberColumn = "donations";
  final String _donationsWeightColumn = "weight";
  final String _donationsAgeColumn = "age";
  final String _donationsFrequencyColumn = "frequency";
  final String _donationsLastDonationColumn = "last_don";
  final String _donationsEducationColumn = "education";
  final String _donationsOccupationColumn = "occupation";
  final String _donationsLivingColumn = "living";
  final String _donationsEligibilityColumn = "eligibility";
  final String _donationsFutureWillingnessColumn = "future_will";


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
            $_requestIdColumnName TEXT PRIMARY KEY,
            $_patientNameColumnName TEXT NOT NULL,
            $_contactColumnName TEXT NOT NULL,
            $_hospitalNameColumn TEXT NOT NULL,
            $_residenceNameColumn TEXT NOT NULL,
            $_caseNameColumn TEXT NOT NULL,
            $_bagsNumberColumn INTEGER NOT NULL,
            $_bloodGroupColumn TEXT NOT NULL,
            $_genderTypeColumn TEXT NOT NULL,
            $_detailsColumnName TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $donationsTableName (
            $_donationIdColumnName TEXT PRIMARY KEY,
            $_patientNameColumnName TEXT NOT NULL,
            $_contactColumnName TEXT NOT NULL,
            $_hospitalNameColumn TEXT NOT NULL,
            $_residenceNameColumn TEXT NOT NULL,
            $_donationsNumberColumn INTEGER NOT NULL,
            $_bloodGroupColumn TEXT NOT NULL,
            $_genderTypeColumn TEXT NOT NULL,
            $_detailsColumnName TEXT,
            $_donationsWeightColumn NUMBER NOT NULL,
            $_donationsAgeColumn INTEGER NOT NULL,
            $_donationsFrequencyColumn TEXT NOT NULL,
            $_donationsLastDonationColumn TEXT NOT NULL,
            $_donationsEducationColumn TEXT NOT NULL,
            $_donationsOccupationColumn TEXT NOT NULL,
            $_donationsLivingColumn TEXT NOT NULL,
            $_donationsEligibilityColumn TEXT NOT NULL,
            $_donationsFutureWillingnessColumn TEXT NOT NULL
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

  Future<void> addRequest(
      String name,
      String contact,
      String hospital,
      String residence,
      String case_,
      int bags,
      String bloodGroup,
      String gender,
      String details) async {
    final db = await database;

    String sql = '''
    INSERT INTO $requestsTableName (
      $_patientNameColumnName, 
      $_contactColumnName, 
      $_hospitalNameColumn, 
      $_residenceNameColumn, 
      $_caseNameColumn, 
      $_bagsNumberColumn, 
      $_bloodGroupColumn, 
      $_genderTypeColumn,
      $_detailsColumnName
    ) VALUES (
      '$name', 
      '$contact', 
      '$hospital', 
      '$residence', 
      '$case_', 
       $bags, 
      '$bloodGroup', 
      '$gender',
      '$details'
    )
  ''';

    await db.rawInsert(sql);
  }

  Future<void> addDonation(
      String name,
      String contact,
      String hospital,
      String residence,
      int donationNumber,
      String bloodGroup,
      String gender,
      String details,
      int weight,
      int age,
      String lastDonated,
      String donationFrequency,
      String highestEducation,
      String currentOccupation,
      String currentLivingArrg,
      String eligibilityTest,
      String futureDonationWillingness) async {
    final db = await database;

    String sql = '''
    INSERT INTO $donationsTableName (
      $_patientNameColumnName, 
      $_contactColumnName, 
      $_hospitalNameColumn, 
      $_residenceNameColumn, 
      $_donationsNumberColumn, 
      $_bloodGroupColumn, 
      $_genderTypeColumn,
      $_detailsColumnName,
      $_donationsWeightColumn,
      $_donationsAgeColumn,
      $_donationsFrequencyColumn,
      $_donationsLastDonationColumn,
      $_donationsEducationColumn,
      $_donationsOccupationColumn,
      $_donationsLivingColumn,
      $_donationsEligibilityColumn,
      $_donationsFutureWillingnessColumn
    ) VALUES (
      '$name', 
      '$contact', 
      '$hospital', 
      '$residence', 
      $donationNumber, 
      '$bloodGroup', 
      '$gender',
      '$details',
       '$weight',
       '$age',
       '$lastDonated',
       '$donationFrequency',
       '$highestEducation',
       '$currentOccupation',
       '$currentLivingArrg',
       '$eligibilityTest',
       '$futureDonationWillingness')
      
    )
  ''';

    await db.rawInsert(sql);
  }

  Future<List<Request>> getRequest() async {
    final db = await database;

    String sql = '''
    SELECT 
      $_requestIdColumnName AS id, 
      $_patientNameColumnName AS name, 
      $_contactColumnName AS contact, 
      $_hospitalNameColumn AS hospital, 
      $_residenceNameColumn AS residence, 
      $_caseNameColumn AS case_, 
      $_bagsNumberColumn AS bags, 
      $_bloodGroupColumn AS bloodGroup, 
      $_genderTypeColumn AS gender,
      $_detailsColumnName AS details
    FROM $requestsTableName
  ''';

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    List<Request> requests = results
        .map((e) => Request(
              id: e['id'] as String,
              name: e['name'] as String,
              contact: e['contact'] as String,
              hospital: e['hospital'] as String,
              residence: e['residence'] as String,
              case_: e['case_'] as String,
              bags: e['bags'] as int,
              bloodGroup: e['bloodGroup'] as String,
              gender: e['gender'] as String,
              details: e['details'] as String,
              userId: e['userId'] as String, createdAt: ''
            ))
        .toList();

    return requests;
  }

  Future<List<Donation>> getDonation() async {
    final db = await database;

    String sql = '''
    SELECT 
      $_requestIdColumnName AS id, 
      $_patientNameColumnName AS name, 
      $_contactColumnName AS contact, 
      $_hospitalNameColumn AS hospital, 
      $_residenceNameColumn AS residence, 
      $_bloodGroupColumn AS bloodGroup, 
      $_genderTypeColumn AS gender, 
      $_donationsNumberColumn AS donationsDone,
      $_detailsColumnName AS details,
      $_donationsWeightColumn AS weight,
      $_donationsAgeColumn AS age,
      $_donationsFrequencyColumn AS frequency,
      $_donationsLastDonationColumn AS last_donation,
      $_donationsEducationColumn AS education,
      $_donationsOccupationColumn AS occupation,
      $_donationsLivingColumn AS living,
      $_donationsEligibilityColumn AS eligibility,
      $_donationsFutureWillingnessColumn AS future_will
    FROM $donationsTableName
  ''';

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    List<Donation> donations = results
        .map((e) => Donation(
              id: e['id'] as String,
              name: e['name'] as String,
              contact: e['contact'] as String,
              hospital: e['hospital'] as String,
              residence: e['residence'] as String,
              bloodGroup: e['bloodGroup'] as String,
              gender: e['gender'] as String,
              donationsDone: e['donationsDone'] as int,
              details: e['details'] as String,
              userId: e['userId'] as String,
              weight: e['weight'] as int,
              age: e['age'] as int,
              lastDonated: e['last_donated'] as String,
              donationFrequency: e['donation_frequency'] as String,
              highestEducation: e['education'] as String,
              currentOccupation: e['occupation'] as String,
              currentLivingArrg: e['living'] as String,
              eligibilityTest: e['eligible'] as String,
              futureDonationWillingness: e['future_will'] as String, createdAt: ''
    ))
        .toList();

    return donations;
  }

  Future<void> updateRequest(
      {required String id,
      String name = '',
      String contact = '',
      String hospital = '',
      String residence = '',
      String case_ = '',
      int bags = -1,
      String bloodGroup = '',
      String gender = '',
      String details=''
      }) async {
    final db = await database;

    try {
      if (name != '') {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_patientNameColumnName = '$name' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (contact != '') {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_contactColumnName = '$contact' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (case_ != '') {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_caseNameColumn = '$case_' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (residence != '') {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_residenceNameColumn = '$residence' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (bags != -1) {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_bagsNumberColumn = '$bags' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (bloodGroup != '') {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_bloodGroupColumn = '$bloodGroup' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (gender != '') {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_genderTypeColumn = '$gender' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (details != '') {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_detailsColumnName = '$details' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (hospital != '') {
        String sql = '''
    UPDATE $requestsTableName
    SET 
      $_hospitalNameColumn = '$hospital' WHERE $_requestIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
    } catch (e) {
      debugPrint("ERROR IN UPDATING REQUEST: $e");
    }
  }


  Future<void> updateDonationAppeal(
      {required String id,
        String name = '',
        String contact = '',
        String hospital = '',
        String residence = '',
        int donationsDone = -1,
        String bloodGroup = '',
        String gender = '',
        String details='',
        int weight=-1,
        int age=-1,
        String lastDonated='',
        String donationFrequency='',
        String highestEducation='',
        String currentOccupation='',
        String currentLivingArrg='',
        String eligibilityTest='',
        String futureDonationWillingness=''}) async {
    final db = await database;
    try {
      if (name != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_patientNameColumnName = '$name' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (contact != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_contactColumnName = '$contact' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (donationsDone != -1) {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsNumberColumn = '$donationsDone' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (residence != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_residenceNameColumn = '$residence' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (bloodGroup != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_bloodGroupColumn = '$bloodGroup' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (gender != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_genderTypeColumn = '$gender' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (details != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_detailsColumnName = '$details' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (hospital != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_hospitalNameColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (lastDonated != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsLastDonationColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (age != -1) {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsAgeColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (weight != -1) {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsWeightColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (donationFrequency != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsFrequencyColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (highestEducation != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsEducationColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (currentOccupation != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsOccupationColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (currentLivingArrg != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsLivingColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }

      if (eligibilityTest != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsEligibilityColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }
      if (futureDonationWillingness != '') {
        String sql = '''
    UPDATE $donationsTableName
    SET 
      $_donationsFutureWillingnessColumn = '$hospital' WHERE $_donationIdColumnName = $id
  ''';
        await db.rawUpdate(sql);
      }


    } catch (e) {
      debugPrint("ERROR IN UPDATING DONATION APPEAL: $e");
    }
  }




  Future<void> deleteRequest(String id) async {
    final db = await database;
    try {
      await db.delete(requestsTableName,
          where: '$_requestIdColumnName = ?',
          whereArgs: [
            id,
          ]);
    } catch (e) {
      debugPrint("ERROR IN DELETING REQUEST: $e");
    }
  }

  Future<void> deleteDonation(String id) async {
    final db = await database;
    try {
      await db.delete(donationsTableName,
          where: '$_donationIdColumnName = ?',
          whereArgs: [
            id,
          ]);
    } catch (e) {
      debugPrint("ERROR IN DELETING DONATION APPEAL: $e");
    }
  }

  Future<void> deleteInventory(int id) async {
    final db = await database;
    try {
      await db.delete(_inventoryTableName,
          where: '$_inventoryIdColumnName = ?',
          whereArgs: [
            id,
          ]);
    } catch (e) {
      debugPrint("ERROR IN DELETING INVENTORY: $e");
    }
  }

  Future<int?> noOfRequests() async {
    final db = await database; // Ensure `database` is initialized
    try {
      final result =
          await db.rawQuery('SELECT COUNT(*) as count FROM $requestsTableName');
      return Sqflite.firstIntValue(result) ?? 0; // Extract the count
    } catch (e) {
      debugPrint("Error in noOfRequests(): $e");
      return null; // Return null if an exception occurs
    }
  }

  Future<int?> noOfDonors() async {
    final db = await database; // Ensure `database` is initialized
    try {
      final result = await db
          .rawQuery('SELECT COUNT(*) as count FROM $donationsTableName');
      return Sqflite.firstIntValue(result) ?? 0; // Extract the count
    } catch (e) {
      debugPrint("Error in noOfRequests(): $e");
      return null; // Return null if an exception occurs
    }
  }

  Future<void> addInventory(String name, String bloodGroup, double hemoglobin,
      double concentration, String rh, String gender, int number) async {
    final db = await database;

    String sql = '''
    INSERT INTO $_inventoryTableName (
      $_inventoryNameColumnName, 
      $_inventoryNumberColumnName, 
      $_inventoryBloodTypeColumnName, 
      $_inventoryBloodHaemoglobinlevel, 
      $_inventoryBloodConcentrationColumnName, 
      $_inventoryBloodRhFactorColumn, 
      $_inventoryGenderColumnName
    ) VALUES (
      '$name', 
      $number, 
      '$bloodGroup', 
      $hemoglobin, 
      $concentration, 
      '$rh', 
      '$gender'
    )
  ''';

    await db.rawInsert(sql);
  }

  Future<List<BloodInventory>> getInventory() async {
    final db = await database;

    String sql = '''
    SELECT 
      $_inventoryIdColumnName AS id, 
      $_inventoryNameColumnName AS name, 
      $_inventoryBloodHaemoglobinlevel AS hemoglobin, 
      $_inventoryBloodConcentrationColumnName AS concentration, 
      $_inventoryBloodTypeColumnName AS bloodgroup, 
      $_inventoryBloodRhFactorColumn AS rh, 
      $_inventoryGenderColumnName AS gender, 
      $_inventoryNumberColumnName AS number
    FROM $_inventoryTableName
  ''';

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    List<BloodInventory> inventory = results
        .map((e) => BloodInventory(
              id: e['id'] as int,
              name: e['name'] as String,
              hemoglobin: e['hemoglobin'] as double,
              concentration: e['concentration'] as double,
              bloodgroup: e['bloodgroup'] as String,
              rh: e['rh'] as String,
              gender: e['gender'] as String,
              number: e['number'] as int,
            ))
        .toList();

    return inventory;
  }
}




