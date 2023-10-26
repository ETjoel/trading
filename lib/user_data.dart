import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserData {
  String id;
  int isCoin;
  List<List<num>> history;
  num investment;
  UserData(this.id, this.isCoin, this.history, this.investment);
  factory UserData.fromMap(Map<String, dynamic> map) {
    final userData = UserData(
        map['id'],
        map['isCoin'],
        (jsonDecode(map['history']) as List<dynamic>)
            .map((e) => [e[0] as num, e[1] as num])
            .toList(),
        map['investment']);
    return userData;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isCoin': isCoin,
      'history': history.toString(),
      'investment': investment
    };
  }

  static void updateInvestment(UserData userData, num val) {
    userData.investment += val;
  }
}

class UserDataDB {
  static const dbName = 'user_data';
  late Database db;

  // UserDataDB() {
  //   initializeDB();
  // }
  Future<void> initializeDB() async {
    final databasePath = await getDatabasesPath();
    const databaseName = 'user_data';
    db = await openDatabase(join(databasePath, dbName), version: 1,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE user_data (id TEXT PRIMARY KEY, isCoin INTEGER, history TEXT, investment REAL)
        ''');
    });
    print('user_data db initialized');
  }

  Future<void> insertUserDataDb(UserData userMap) async {
    await initializeDB();
    tableExist();
    final result =
        await db.query('user_data', where: 'id = ?', whereArgs: [userMap.id]);
    if (result.isEmpty) {
      await db.insert('user_data', userMap.toMap());
    } else {
      UserData userData = UserData.fromMap(result[0]);
      List<List<num>> temp = userData.history;
      temp.add(userMap.history[0]);
      final updates = {
        'history': temp.toString(),
        'investment': userData.investment + userMap.investment
      };
      await db.update('user_data', updates,
          where: 'id = ?', whereArgs: [userMap.id]);
    }
  }

  Future<List<UserData>> fetchUserData() async {
    await initializeDB();
    tableExist();
    final result = await db.query('user_data');
    if (result.length > 0) {
      print(result);
      return List.generate(
          result.length, (index) => UserData.fromMap(result[index]));
    } else {
      return [];
    }
  }

  Future<void> tableExist() async {
    final table = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='user_data'");
    if (table.isEmpty) {
      print('table does not exist');
      await db.execute(
          '''CREATE TABLE user_data (id TEXT PRIMARY KEY, isCoin INTEGER, history TEXT, investment REAL)''');
    } else {
      print('table exist');
    }
  }
}
