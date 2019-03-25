import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_yt_example/models/person.dart';
import 'package:uuid/uuid.dart';

class PersonDB {
  // Singleton
  static final PersonDB _instance = PersonDB._internal();
  factory PersonDB() => _instance;

  static Database _db;

  // Private Constructor
  PersonDB._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _initDb();
      return _db;
    }
  }

  Future<Database> _initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'appperson.db');
    Database personDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return personDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS Person (
    id VARCHAR(200) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
    );
    """);
    print('Db Table is created');
  }

  // Insert Person
  Future<int> insert({@required Person person}) async {
    var personDB = await db;
    person.id = Uuid().v1();
    int res = await personDB.insert("Person", person.toMap());
    return res;
  }

  // Get all persons
  Future<List<Person>> getAll() async {
    var personDB = await db;
    var res = await personDB.query('Person');
    List<Person> personList = res.isNotEmpty ? res.map((personMap) => Person.fromMap(personMap)).toList() : [];
    return personList;
  }

  // Get specific person
  Future<Person> getPerson({@required String id}) async {
    var personDB = await db;
    var res = await personDB.query('Person', where: 'id = ?', whereArgs: [id]);
    // var rawRes = await personDB.rawQuery('SELECT * FROM LIST WHERE id = $id');
    return res.isNotEmpty ? Person.fromMap(res.first) : null;
  }

  // Update a person
  Future<int> update({@required Person newPerson}) async {
    var personDB = await db;
    var res = await personDB.update('Person', newPerson.toMap(), where: 'id = ?', whereArgs: [newPerson.id]);
    return res;
  }

  // Delete a person
  Future<int> delete({@required String id}) async {
    var personDB = await db;
    var res = await personDB.delete('Person', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  // Delete all
  Future<int> deleteAll() async {
    var personDB = await db;
    var res = await personDB.delete('Person');
    return res;
  }
}
