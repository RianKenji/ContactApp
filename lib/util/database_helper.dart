import 'dart:io';
import 'package:contact/models/contact.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'ContactDB.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  late Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
    /*Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    print(dbPath);*/
    return await openDatabase(_databaseName, version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async{
    await db.execute(''
        'CREATE TABLE ${Contact.tblContact}('
        '${Contact.colID} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${Contact.colName} TEXT NOT NULL,'
        '${Contact.colMobile} TEXT NOT NULL');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(Contact.tblContact, contact.toMap());
  }

  Future<int> updateContact (Contact contact) async{
    Database db = await database;
    return await db.delete(Contact.tblContact, where: '${Contact.colID}=?',
        whereArgs: [contact.id]);
  }

  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List<Map<String,dynamic>> contacts = await db.query(Contact.tblContact);
    return contacts.length == 0 ? [] : contacts.map((e) => Contact.fromMap(e)).toList();
  }
}