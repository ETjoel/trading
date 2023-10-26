import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:stock/api_json.dart';

class StockDatabase {
  late Database db;
  final stockTable = 'stock_model';

  StockDatabase()  {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<void> initializeDb() async {
    final databasePath = await getDatabasesPath();
    const databaseName = 'stocks';
    print('db is about to be opened');
    db = await openDatabase(
      join(databasePath, databaseName),
      version: 1,
      onCreate: (db, version) async {
        print('creating table');
        await db.execute('''
          CREATE TABLE $stockTable (ticker TEXT PRIMARY KEY,c REAL,h REAL,l REAL,n REAL,o REAL,t REAL,v REAL,vw REAL);
          ''' );
        await db.execute('''
          CREATE TABLE stock_detail (Symbol TEXT PRIMARY KEY, AssetType TEXT, Name TEXT, Description TEXT, Country TEXT, Sector TEXT, Industry TEXT, Address TEXT, Exchange TEXT, Currency TEXT);
          ''' );
      }
    );
  }

  Future<void> insertStock(List<GroupedDaily2> stocks) async {
    await db.delete(stockTable);
    for (final stock in stocks) {
      await db.insert(
          stockTable,
          stock.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }
  }
  Future<void> insertStockDetail(StockDetail stockDetail) async {
    final tables = await db.query('sqlite_master', where: 'name = ?', whereArgs: ['stock_detail']);
    if (tables.isEmpty) {
      await db.execute('''
          CREATE TABLE stock_detail (Symbol TEXT PRIMARY KEY, AssetType TEXT, Name TEXT, Description TEXT, Country TEXT, Sector TEXT, Industry TEXT, Address TEXT, Exchange TEXT, Currency TEXT);
          ''' );
    }
    await db.insert('stock_detail', stockDetail.toMap(stockDetail));
  }
  Future<List<GroupedDaily2>> fetchStocks() async {
    List<Map<String, dynamic>> queries = await db.query(stockTable);
    return List.generate(queries.length, (index) {
      return GroupedDaily2.fromMap(queries[index]);
    }
    );
  }
  Future<List<StockDetail>> fetchStockDetailDB(String symbol) async {
    final tables = await db.query('sqlite_master', where: 'name = ?', whereArgs: ['stock_detail']);
    if (tables.isEmpty) {
      await db.execute('''
          CREATE TABLE stock_detail (Symbol TEXT PRIMARY KEY, AssetType TEXT, Name TEXT, Description TEXT, Country TEXT, Sector TEXT, Industry TEXT, Address TEXT, Exchange TEXT, Currency TEXT);
          ''' );
    }
    final response = await db.query('stock_detail', where: 'Symbol = ?', whereArgs: [symbol]);
    return response.map((e) => StockDetail.fromJson(e)).toList();
  }
}
// void main() async {
//   StockDatabase stdb = StockDatabase();
//   Stocks stocks = Stocks();
//   final result = await stocks.getIntraday('60min', 'IBM');
//   print(result);
// }
