import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'notes.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate,
        version: 7,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    print("onUpgrade =====================================");
  }

  _onOpen(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  _onCreate(Database db, int version) async {
    await db.execute("PRAGMA foreign_keys = ON");

    await db.execute('''
CREATE TABLE "note" (
   "noteId" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
    "title" TEXT NOT NULL,
    "iconColorIndex" INTEGER NOT NULL,
    "content" TEXT
    
  ) ''');

    print("notes created");

    print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

// SELECT
// DELETE
// UPDATE
// INSERT
}
