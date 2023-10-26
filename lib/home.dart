import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stock/api_json.dart';
import 'package:stock/detail.dart';
import 'package:stock/profile.dart';
import 'package:stock/stock_database.dart';
import 'package:stock/stocks.dart';
import 'package:waiting_animation/triangle.dart';

import 'coinsView.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              //title: Text(title),
              ),
          body: TabBarView(
            children: [
              Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    elevatedButttons(),
                    Expanded(child: listOfStocks())
                  ])),
              const Center(child: CoinsView()),
              Center(child: Profile()),
            ],
          ),
          bottomNavigationBar: TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.black,
            tabs: [
              buildTab('Stocks', 'images/stock.png', () {
                setTitle('Stocks');
              }),
              buildTab('Coins', 'images/cryptocurrency.png', () {
                setTitle('Coins');
              }),
              buildTab('Profile', 'images/cryptocurrency.png', () {
                setTitle('Profile');
              }),
            ],
          ),
        ));
  }

  Tab buildTab(String text, String imagePath, Function() onTap) {
    return Tab(
      icon: Image.asset(imagePath, width: 30, height: 30, scale: 1),
      text: text,
    );
  }

  void setTitle(String newTitle) {
    setState(() {
      title = newTitle;
    });
  }

  Widget elevatedButttons() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width / 2,
        height: 20,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () async {
              final Future<List<dynamic>> tempStock = fetchGrouped();
              final List<GroupedDaily2> temp =
                  (await tempStock).cast<GroupedDaily2>();
              await stockDatabase.insertStock(temp);
              setState(() {
                futureGrouped = fetchGroupedDB();
              });
            },
            child: Image.asset('images/rotation.png'),
          ),
          ElevatedButton(
              onPressed: () async {
                final Future<List<dynamic>> tempStock = fetchGrouped();
                setState(() {
                  futureGrouped = tempStock;
                });
                final List<GroupedDaily2> temp =
                    (await tempStock).cast<GroupedDaily2>();
                await stockDatabase.insertStock(temp);
              },
              child: const Text('R'))
        ]));
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
              child: const CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data in the database');
        } else {
          print(snapshot.data!.length);
          snapshot.data!.sort((a, b) => b.o.compareTo(a.o));
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailedView(item: item)));
                },
                child: ListTile(
                    title: Text(item.ticker),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 100,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 8,
                                      height: 10,
                                      child: TriangleIcon(Colors.green, 0)),
                                  const SizedBox(width: 4),
                                  Text('${item.h}'),
                                ])),
                        SizedBox(
                          width: 100,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                  width: 8,
                                  height: 10,
                                  child: TriangleIcon(Colors.redAccent, pi)),
                              const SizedBox(width: 4),
                              Text('${item.l}')
                            ],
                          ),
                        )
                      ],
                    )),
              );
            },
          );
        }
      },
    );
  }

  Future<List<dynamic>> fetchGrouped() async {
    return await stock.getGrouped('2023-01-09');
  }

  Future<List<dynamic>> fetchGroupedDB() async {
    await stockDatabase.initializeDb();
    return await stockDatabase.fetchStocks();
  }
}
