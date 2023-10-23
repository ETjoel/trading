import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class UserData {
  String id;
  int isCoin;
  num boughtPrice;
  num date;
  UserData(this.id, this.isCoin, this.boughtPrice, this.date);
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(map['id'], map['isCoin'], map['boughtPrice'], map['date']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'isCoin' : isCoin,
      'boughtPrice' : boughtPrice,
      'date' : date
    };
  }
}
class UserDataDB {
  static const dbName = 'user_data';
  late Database db;

  UserDataDB() {
    initializeDB();
  }
  Future<void> initializeDB() async {
    final databasePath = await getDatabasesPath();
    const databaseName = 'user_data';
    db = await openDatabase(
      join(databasePath, dbName),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE user_data (id TEXT PRIMARY KEY, isCoin INTEGER, boughtPrice REAL, date REAL)
        ''');
    }
    );
    print('user_data db initialized');
  }
  
  Future<void> insertUserDataDb(Map<String, dynamic> userMap ) async {
    tableExist();
    await db.insert('user_data', userMap);
  }

  Future<List<UserData>> fetchUserData() async {
    tableExist();
    final result = await db.query('user_data');
    return List.generate(result.length, (index) => UserData.fromMap(result[index]));
  }

  // Future<void> updateUserData(UserData user) async {
  //
  //
  // }
  Future<void> tableExist() async {
    final table = await db.query('sqlite_master', where: 'name = ?', whereArgs: [dbName]);
    if (table.isEmpty) {
      db.execute('''CREATE TABLE user_data (id TEXT PRIMARY KEY, isCoin INTEGER, boughtPrice REAL, date REAL''');
    }
  }
}

