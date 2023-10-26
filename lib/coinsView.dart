import 'package:flutter/material.dart';
import 'package:stock/coin_detail.dart';
import 'package:stock/database.dart';

import 'api_json.dart';
import 'coins.dart';

class CoinsView extends StatefulWidget {
  const CoinsView({Key? key}) : super(key: key);

  @override
  State<CoinsView> createState() => _CoinsViewState();
}

class _CoinsViewState extends State<CoinsView> {
  Coins coins = Coins();
  late Future<List<CoinModel>> futureCoins;

  @override
  void initState() {
    super.initState();
    futureCoins = fetchCoinsDB();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(children: [
      SizedBox(
          width: size.width / 3,
          height: 20,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () async {
                final Future<List<CoinModel>> tempCoin = fetchCoins();
                final List<CoinModel> temp = await tempCoin;
                ManageCoinDB.updateCoinDB(temp);
                setState(() {
                  futureCoins = fetchCoinsDB();
                });
              },
              child: Image.asset('images/rotation.png'),
            ),
            ElevatedButton(
                onPressed: () async {
                  final Future<List<CoinModel>> tempCoin = fetchCoins();
                  setState(() {
                    futureCoins = tempCoin;
                  });
                  final List<CoinModel> temp = await tempCoin;
                  ManageCoinDB.insertCoins(temp);
                },
                child: const Text('R'))
          ])),
      Expanded(child: futureBuilder()),
    ]);
  }

  Widget futureBuilder() {
    return FutureBuilder<List<CoinModel>>(
        future: futureCoins,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Colors.white70),
                child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('The database is Empty');
          } else {
            final List<CoinModel> coins = snapshot.data!;
            coins.sort((CoinModel a, CoinModel b) =>
                a.marketCapRank!.toInt().compareTo(b.marketCapRank!.toInt()));
            coins.reversed;
            print('coins length: ${coins.length}');
            return listCoins(coins);
          }
        });
  }

  Widget listCoins(List<CoinModel> coins) {
    return ListView.builder(
        itemCount: coins.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CoinDetail(
                          coinModel: coins[index],
                        )));
              },
              child: ListTile(
                leading: Image.network(coins[index].image,
                    filterQuality: FilterQuality.low, width: 40, height: 40),
                title: Text(coins[index].name),
                subtitle: Text(coins[index].symbol),
                trailing: Text(coins[index].currentPrice.toStringAsFixed(2)),
              ));
        });
  }

  Future<List<CoinModel>> fetchCoins() {
    return coins.getCoins();
  }

  Future<List<CoinModel>> fetchCoinsDB() {
    return ManageCoinDB.fetchCoinDB();
  }

  Future<void> updateDB() async {
    ManageCoinDB.updateCoinDB(await fetchCoins());
    futureCoins = fetchCoinsDB();
  }
}
