import 'package:flutter/material.dart';
import 'package:stock/three_dot_waiting.dart';
import 'package:stock/user_data.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<List<UserData>> userData;
  UserDataDB userDataDB = UserDataDB();

  @override
  void initState() {
    super.initState();
    userData = fetchUserDataDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Center(child: futureBuilder()));
  }

  Widget futureBuilder() {
    return FutureBuilder<List<UserData>>(
      future:
          userData, // Make sure `userData` is a valid `Future` of `List<UserData>`.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 200,
            height: 100,
            child: ThreeDotWaiting(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data!.isEmpty) {
          return const Text('Empty database');
        } else {
          List<UserData> result = snapshot.data!;
          List<UserData> coins = [];
          List<UserData> stocks = [];
          for (final coin in result) {
            if (coin.isCoin == 1) {
              coins.add(coin);
            } else {
              stocks.add(coin);
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Coins'),
              Expanded(child: coinFutureBuilder(coins)),
              Text(stocks.isNotEmpty ? 'Stocks' : ''),
              Expanded(child: stockFutureBuilder(stocks))
            ],
          );
        }
      },
    );
  }

  Widget coinFutureBuilder(List<UserData> coins) {
    return ListView.builder(
      itemCount: coins.length,
      itemBuilder: (builder, index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            setState(() {
              coins.removeAt(index);
            });
          },
          child: ListTile(
            title: Text(coins[index].id),
            subtitle: Text(coins[index].isCoin == 1 ? 'coin' : 'stock'),
            trailing: Text(coins[index].investment.toStringAsFixed(9)),
          ),
        );
      },
    );
  }

  Widget stockFutureBuilder(List<UserData> stocks) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (builder, index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            setState(() {
              stocks.removeAt(index);
            });
          },
          child: ListTile(
            title: Text(stocks[index].id),
            subtitle: Text(stocks[index].isCoin == 1 ? 'coin' : 'stock'),
            trailing: Text(stocks[index].investment.toStringAsFixed(9)),
          ),
        );
      },
    );
  }

  Future<List<UserData>> fetchUserDataDB() async {
    return await userDataDB.fetchUserData();
  }
}
