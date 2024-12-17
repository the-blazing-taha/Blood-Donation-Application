import 'dart:ffi';

import 'package:blood/models/requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> updateRequest(int id, String name, String contact, String hospital, String residence, String case_, int bags, String bloodGroup,String gender) async {
    final db = await database;
    await db.update(
      requestsTableName,
      {
        _patientNameColumnName: name,
        _contactColumnName: contact,
        _hospitalNameColumn: hospital,
        _residenceNameColumn: residence,
        _bagsNumberColumn:bags,
        _bloodGroupColumn:bloodGroup,
        _genderTypeColumn: gender,
      },
      where: '$_requestIdColumnName = ?', // Use the correct column name
      whereArgs: [id,],
    );
  }

  Future<void> deleteRequest(int id) async {
    final db = await database;
    try {
      await db
          .delete(requestsTableName, where: '$_requestIdColumnName = ?', whereArgs: [
        id,
      ]);
    }
    catch(e){
      print(e);
    }
  }
}


class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({required username,required String email,required String password})async{
    String res= "Some error occured!";
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email,password: password);
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'name':username,
        'email': email,
        'uid':credential.user!.uid,
      });
      res = "Successfully";
    }
    catch(e){
      print(e.toString());
    }
    return res;
  }
}
