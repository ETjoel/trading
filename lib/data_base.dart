import 'package:sqflite/sqflite.dart' as sql;

import 'api_json.dart';

class ManageCoinDB {
  String coinDBName = 'coins.db';

  static Future<void> createCoinTables(sql.Database db) async {
    db.execute('''
        CREATE TABLE coin_model (
        id TEXT PRIMARY KEY,
        symbol TEXT,
        name TEXT,
        image TEXT,
        current_price REAL,
        market_cap REAL,
        market_cap_rank REAL,
        fully_diluted_valuation REAL,
        total_volume REAL,
        high_24h REAL,
        low_24h REAL,
        price_change_24h REAL,
        price_change_percentage_24h REAL,
        market_cap_change_24h REAL,
        market_cap_change_percentage_24h REAL,
        circulating_supply REAL,
        total_supply REAL,
        max_supply REAL,
        ath REAL,
        ath_change_percentage REAL,
        ath_date TEXT,
        atl REAL,
        atl_change_percentage REAL,
        atl_date TEXT,
        last_updated TEXT,
        price TEXT,
        price_change_percentage_24h_in_currency REAL,
        current_holdings REAL
        );
        ''');
    // final result =
    //     await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    db.close();
    // final tables = result.map((row) => row['name'] as String).toList();
    // print(tables);
  }

  static Future<void> createCoinDetailTable(sql.Database db) async {
    db.execute('''
     CREATE TABLE coin_detail_model (
         id TEXT PRIMARY KEY,
         description TEXT,
         homepage TEXT,
         image TEXT
        );
    ''');
  }

  static Future<sql.Database> _openDatabase() async {
    return sql.openDatabase('coins.db', version: 2,
        onCreate: (sql.Database database, int version) async {
      await createCoinTables(database);
      await createCoinDetailTable(database);
    });
  }

  static Future<void> insertCoins(List<CoinModel> coinModel) async {
    final db = await _openDatabase();
    for (CoinModel coin in coinModel) {
      await db.insert('coin_model', coin.toMap(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<void> insertCoinsDetail(Map<String, dynamic> coin) async {
    final db = await _openDatabase();
    final result = await db.query('sqlite_master',
        where: 'name = ?', whereArgs: ['coin_detail_model']);
    if (result.isEmpty) {
      await createCoinDetailTable(db);
    }
    await db.insert('coin_detail_model', coin,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<CoinModel>> fetchCoinDB() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> allData = await db.query('coin_model');
    return allData.map((coin) => CoinModel.fromMap(coin)).toList();
  }

  static Future<List<CoinModel>> fetchFavoriteCoin(List<String> ids) async {
    final db = await _openDatabase();
    final placeholders = List.filled(ids.length, '?').join(', ');
    final whereStmnt = 'id IN ($placeholders)';
    final List<Map<String, dynamic>> allData =
        await db.query('coin_model', where: whereStmnt, whereArgs: ids);
    return allData.map((coin) => CoinModel.fromMap(coin)).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchCoinDetailDB(String id) async {
    final db = await _openDatabase();
    final tabels = await db.query('sqlite_master',
        where: 'name = ?', whereArgs: ['coin_detail_model']);
    if (tabels.isEmpty) {
      await createCoinDetailTable(db);
    }
    final List<Map<String, dynamic>> allData =
        await db.query('coin_detail_model', where: 'id = ?', whereArgs: [id]);
    // final result =
    //     await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    return allData;
  }

  static Future<void> updateCoinDB(List<CoinModel> coinModels) async {
    final db = await _openDatabase();
    for (final coin in coinModels) {
      final Map<String, dynamic> temp = coin.toUpdatedMap();
      await db
          .update('coin_model', temp, where: 'id = ?', whereArgs: [coin.id]);
    }
  }
}
