import 'package:flutter/material.dart';
import 'package:stock/three_dot_waiting.dart';
import 'stocks.dart';
import 'stock_database.dart';
import 'package:waiting_animation/triangle.dart';
import 'api_json.dart';
import 'stock_detail.dart';
import 'dart:math';

class StockList extends StatefulWidget {
  const StockList({Key? key}) : super(key: key);
  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  late Future<List<dynamic>> futureGrouped;
  Stocks stock = Stocks();
  String title = 'Stocks';
  StockDatabase stockDatabase = StockDatabase();

  @override
  void initState() {
    super.initState();
    futureGrouped = fetchGroupedDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          iconTheme: IconThemeData(color: Colors.grey.shade700, size: 20),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: listOfStocks()));
  }

  SizedBox buildReloadButton() {
    return SizedBox(
        height: 40,
        child: Row(
          children: [
            TextButton(
                onPressed: () {},
                child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Sort by Rank',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ))),
            const SizedBox(width: 5),
            TextButton(
                onPressed: () {},
                child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Sort by Price',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ))),
            const Spacer(),
            TextButton(
              onPressed: () async {
                final Future<List<dynamic>> tempStock = fetchGrouped();
                setState(() {
                  futureGrouped = tempStock;
                });
                final List<GroupedDaily2> temp =
                    (await tempStock).cast<GroupedDaily2>();
                await stockDatabase.insertStock(temp);
              },
              child: Image.asset(
                'images/rotation.png',
                width: 20,
                height: 20,
              ),
            ),
          ],
        ));
  }

  Widget listOfStocks() {
    return FutureBuilder<List<dynamic>>(
      future: futureGrouped,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.white70),
              child: const ThreeDotWaiting());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data in the database');
        } else {
          // print(snapshot.data!.length);
          snapshot.data!.sort((a, b) => b.o.compareTo(a.o));
          return Column(
            children: [
              buildReloadButton(),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Column(
                      children: [
                        gestureDetector(context, item),
                        const Divider()
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  GestureDetector gestureDetector(BuildContext context, item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailedView(ticker: item.ticker)));
      },
      child: ListTile(
          title: Text(item.ticker),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 100,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 8,
                            height: 10,
                            child: TriangleIcon(Colors.green, 0)),
                        const SizedBox(width: 4),
                        Text('${item.h.toStringAsFixed(2)}'),
                      ])),
              SizedBox(
                width: 100,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 8,
                        height: 10,
                        child: TriangleIcon(Colors.redAccent, pi)),
                    const SizedBox(width: 4),
                    Text('${item.l.toStringAsFixed(2)}')
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<List<dynamic>> fetchGrouped() async {
    final temp = DateTime.now().subtract(const Duration(days: 3));
    return await stock.getGrouped(temp.toString().split(' ')[0]);
  }

  Future<List<dynamic>> fetchGroupedDB() async {
    await stockDatabase.initializeDb();
    return await stockDatabase.fetchStocks();
  }
}
