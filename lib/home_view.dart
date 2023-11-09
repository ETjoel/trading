import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:stock/api_json.dart';
import 'package:stock/stock_detail.dart';
import 'package:stock/stock_database.dart';
import 'package:stock/stocks.dart';
import 'three_dot_waiting.dart';
import 'coins_view.dart';
import 'stock_list.dart' as list_view;
import 'coin_detail.dart';
import 'data_base.dart';
import 'profile.dart';
import 'user_data.dart';
import 'coins.dart';
import 'package:provider/provider.dart';
import 'calculating.dart';

class AppData extends ChangeNotifier {
  late Map<String, CoinModel> allCoins;
  late Map<String, Map<String, StockData>> allStocks;

  AppData() {
    allCoins = {};
    allStocks = {'actives': {}, 'losers': {}, 'gainers': {}};
    initializeData();
  }

  Future<void> initializeData() async {
    final coins = await Coins().getCoins();
    allCoins = {for (var coin in coins) coin.id: coin};

    // final stockDatas = await Stocks().fetchMostActiveStocks();
    final stockDatas = StockList.fromJson(fetchMostStock());
    for (final stock in stockDatas.mostActivelyTraded) {
      allStocks['actives']![stock.ticker] = stock;
    }
    for (final stock in stockDatas.topGainers) {
      allStocks['gainers']![stock.ticker] = stock;
    }
    for (final stock in stockDatas.topLosers) {
      allStocks['losers']![stock.ticker] = stock;
    }
    notifyListeners();
  }

  Map<String, dynamic> fetchMostStock() {
    return {
      "metadata": "Top gainers, losers, and most actively traded US tickers",
      "last_updated": "2023-11-08 16:15:58 US/Eastern",
      "top_gainers": [
        {
          "ticker": "ODVWW",
          "price": "0.0999",
          "change_amount": "0.0893",
          "change_percentage": "842.4528%",
          "volume": "24506"
        },
        {
          "ticker": "IMACW",
          "price": "0.0099",
          "change_amount": "0.0064",
          "change_percentage": "182.8571%",
          "volume": "3100"
        },
        {
          "ticker": "TGVCW",
          "price": "0.054",
          "change_amount": "0.0341",
          "change_percentage": "171.3568%",
          "volume": "145127"
        },
        {
          "ticker": "BRSHW",
          "price": "0.0199",
          "change_amount": "0.0123",
          "change_percentage": "161.8421%",
          "volume": "600"
        },
        {
          "ticker": "HSCSW",
          "price": "0.06",
          "change_amount": "0.0351",
          "change_percentage": "140.9639%",
          "volume": "4904"
        },
        {
          "ticker": "CMRAW",
          "price": "0.0234",
          "change_amount": "0.0133",
          "change_percentage": "131.6832%",
          "volume": "15900"
        },
        {
          "ticker": "SHOTW",
          "price": "0.49",
          "change_amount": "0.27",
          "change_percentage": "122.7273%",
          "volume": "17562"
        },
        {
          "ticker": "PRSO",
          "price": "0.323",
          "change_amount": "0.1698",
          "change_percentage": "110.8355%",
          "volume": "99030510"
        },
        {
          "ticker": "ASCBW",
          "price": "0.0154",
          "change_amount": "0.008",
          "change_percentage": "108.1081%",
          "volume": "4003"
        },
        {
          "ticker": "HNRA+",
          "price": "0.0587",
          "change_amount": "0.0282",
          "change_percentage": "92.459%",
          "volume": "2900"
        },
        {
          "ticker": "TNONW",
          "price": "0.115",
          "change_amount": "0.055",
          "change_percentage": "91.6667%",
          "volume": "1047652"
        },
        {
          "ticker": "PRENW",
          "price": "0.03",
          "change_amount": "0.0137",
          "change_percentage": "84.0491%",
          "volume": "47636"
        },
        {
          "ticker": "GAN",
          "price": "1.63",
          "change_amount": "0.7382",
          "change_percentage": "82.7764%",
          "volume": "15616760"
        },
        {
          "ticker": "BBLGW",
          "price": "3.5",
          "change_amount": "1.5",
          "change_percentage": "75.0%",
          "volume": "4196"
        },
        {
          "ticker": "SONDW",
          "price": "0.0275",
          "change_amount": "0.0116",
          "change_percentage": "72.956%",
          "volume": "10804"
        },
        {
          "ticker": "RDZNW",
          "price": "0.0295",
          "change_amount": "0.0124",
          "change_percentage": "72.5146%",
          "volume": "109732"
        },
        {
          "ticker": "KRRO",
          "price": "41.4",
          "change_amount": "16.78",
          "change_percentage": "68.156%",
          "volume": "311511"
        },
        {
          "ticker": "ARRWW",
          "price": "0.1065",
          "change_amount": "0.0428",
          "change_percentage": "67.19%",
          "volume": "350"
        },
        {
          "ticker": "FMSTW",
          "price": "0.5",
          "change_amount": "0.2",
          "change_percentage": "66.6667%",
          "volume": "6900"
        },
        {
          "ticker": "OXBRW",
          "price": "0.0898",
          "change_amount": "0.0347",
          "change_percentage": "62.9764%",
          "volume": "7155"
        }
      ],
      "top_losers": [
        {
          "ticker": "MTRYW",
          "price": "0.0014",
          "change_amount": "-0.0238",
          "change_percentage": "-94.4444%",
          "volume": "100292"
        },
        {
          "ticker": "DRRX",
          "price": "0.527",
          "change_amount": "-2.053",
          "change_percentage": "-79.5736%",
          "volume": "15395810"
        },
        {
          "ticker": "BRKHW",
          "price": "0.0051",
          "change_amount": "-0.0096",
          "change_percentage": "-65.3061%",
          "volume": "12078"
        },
        {
          "ticker": "FTCI",
          "price": "0.423",
          "change_amount": "-0.767",
          "change_percentage": "-64.4538%",
          "volume": "28553505"
        },
        {
          "ticker": "CREVW",
          "price": "0.0715",
          "change_amount": "-0.0733",
          "change_percentage": "-50.6215%",
          "volume": "100636"
        },
        {
          "ticker": "NCPLW",
          "price": "0.0455",
          "change_amount": "-0.0444",
          "change_percentage": "-49.3882%",
          "volume": "16729"
        },
        {
          "ticker": "MOBV",
          "price": "4.52",
          "change_amount": "-4.38",
          "change_percentage": "-49.2135%",
          "volume": "85659"
        },
        {
          "ticker": "EUDAW",
          "price": "0.1136",
          "change_amount": "-0.0864",
          "change_percentage": "-43.2%",
          "volume": "6628"
        },
        {
          "ticker": "LIDRW",
          "price": "0.01",
          "change_amount": "-0.0075",
          "change_percentage": "-42.8571%",
          "volume": "2001"
        },
        {
          "ticker": "LMDXW",
          "price": "0.0142",
          "change_amount": "-0.0104",
          "change_percentage": "-42.2764%",
          "volume": "4628"
        },
        {
          "ticker": "LGSTW",
          "price": "0.03",
          "change_amount": "-0.021",
          "change_percentage": "-41.1765%",
          "volume": "16025"
        },
        {
          "ticker": "MLECW",
          "price": "0.0235",
          "change_amount": "-0.0164",
          "change_percentage": "-41.1028%",
          "volume": "96828"
        },
        {
          "ticker": "MOBVU",
          "price": "4.65",
          "change_amount": "-3.13",
          "change_percentage": "-40.2314%",
          "volume": "4267"
        },
        {
          "ticker": "AVHIW",
          "price": "0.03",
          "change_amount": "-0.02",
          "change_percentage": "-40.0%",
          "volume": "20360"
        },
        {
          "ticker": "UONEK",
          "price": "3.45",
          "change_amount": "-2.2",
          "change_percentage": "-38.9381%",
          "volume": "145696"
        },
        {
          "ticker": "BCDAW",
          "price": "0.0673",
          "change_amount": "-0.0427",
          "change_percentage": "-38.8182%",
          "volume": "1140"
        },
        {
          "ticker": "OPTX",
          "price": "5.2",
          "change_amount": "-3.24",
          "change_percentage": "-38.3886%",
          "volume": "128038"
        },
        {
          "ticker": "RFACW",
          "price": "0.0161",
          "change_amount": "-0.0099",
          "change_percentage": "-38.0769%",
          "volume": "3852"
        },
        {
          "ticker": "DPCSW",
          "price": "0.0159",
          "change_amount": "-0.0093",
          "change_percentage": "-36.9048%",
          "volume": "218"
        },
        {
          "ticker": "EXFY",
          "price": "1.83",
          "change_amount": "-1.07",
          "change_percentage": "-36.8966%",
          "volume": "4518152"
        }
      ],
      "most_actively_traded": [
        {
          "ticker": "BETS",
          "price": "0.0297",
          "change_amount": "-0.0073",
          "change_percentage": "-19.7297%",
          "volume": "185427726"
        },
        {
          "ticker": "RIVN",
          "price": "17.0",
          "change_amount": "-0.42",
          "change_percentage": "-2.411%",
          "volume": "120822265"
        },
        {
          "ticker": "SQQQ",
          "price": "18.06",
          "change_amount": "-0.04",
          "change_percentage": "-0.221%",
          "volume": "116509284"
        },
        {
          "ticker": "TSLA",
          "price": "222.11",
          "change_amount": "-0.07",
          "change_percentage": "-0.0315%",
          "volume": "105541682"
        },
        {
          "ticker": "PRSO",
          "price": "0.323",
          "change_amount": "0.1698",
          "change_percentage": "110.8355%",
          "volume": "99030510"
        },
        {
          "ticker": "TQQQ",
          "price": "39.15",
          "change_amount": "0.07",
          "change_percentage": "0.1791%",
          "volume": "93346595"
        },
        {
          "ticker": "CDIO",
          "price": "1.375",
          "change_amount": "-0.005",
          "change_percentage": "-0.3623%",
          "volume": "86933015"
        },
        {
          "ticker": "HSCS",
          "price": "0.229",
          "change_amount": "0.0797",
          "change_percentage": "53.3825%",
          "volume": "85669755"
        },
        {
          "ticker": "WBD",
          "price": "9.4",
          "change_amount": "-2.21",
          "change_percentage": "-19.0353%",
          "volume": "79829669"
        },
        {
          "ticker": "RBLX",
          "price": "39.24",
          "change_amount": "4.17",
          "change_percentage": "11.8905%",
          "volume": "60990566"
        },
        {
          "ticker": "SPY",
          "price": "437.17",
          "change_amount": "0.24",
          "change_percentage": "0.0549%",
          "volume": "60778460"
        },
        {
          "ticker": "TMF",
          "price": "4.9",
          "change_amount": "0.25",
          "change_percentage": "5.3763%",
          "volume": "58641511"
        },
        {
          "ticker": "LABU",
          "price": "3.09",
          "change_amount": "-0.29",
          "change_percentage": "-8.5799%",
          "volume": "55027060"
        },
        {
          "ticker": "TLT",
          "price": "89.56",
          "change_amount": "1.5",
          "change_percentage": "1.7034%",
          "volume": "53595574"
        },
        {
          "ticker": "NKLA",
          "price": "1.02",
          "change_amount": "-0.01",
          "change_percentage": "-0.9709%",
          "volume": "52711129"
        },
        {
          "ticker": "LCID",
          "price": "3.95",
          "change_amount": "-0.35",
          "change_percentage": "-8.1395%",
          "volume": "50960059"
        },
        {
          "ticker": "SOXL",
          "price": "18.69",
          "change_amount": "0.09",
          "change_percentage": "0.4839%",
          "volume": "49777225"
        },
        {
          "ticker": "SOXS",
          "price": "10.66",
          "change_amount": "-0.04",
          "change_percentage": "-0.3738%",
          "volume": "49545294"
        },
        {
          "ticker": "AAPL",
          "price": "182.89",
          "change_amount": "1.07",
          "change_percentage": "0.5885%",
          "volume": "49072463"
        },
        {
          "ticker": "PLTR",
          "price": "18.495",
          "change_amount": "-0.305",
          "change_percentage": "-1.6223%",
          "volume": "45863568"
        }
      ]
    };
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey.shade700, size: 20),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfileView()));
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(right: 20, left: 20),
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            children: [
              const PortfolioCalculate(),
              const SizedBox(height: 15),
              ListTile(
                leading: const Text('Top Coins'),
                trailing: TextButton(
                  child: const Text('See All'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CoinsView()));
                  },
                ),
              ),
              FavoriteCoins(size: size),
              const SizedBox(height: 15),
              ListTile(
                leading: const Text('Top Stocks'),
                trailing: TextButton(
                  child: const Text('See All'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const list_view.StockList()));
                  },
                ),
              ),
              FavoriteStacks(size: size),
            ],
          ),
        ),
      ),
    );
  }

  Widget coinAndStock(Size size, BuildContext context) {
    return Container(
        width: size.width,
        height: size.height / 5,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CoinsView()));
              },
              style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset('images/cryptocurrency.png')),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const list_view.StockList()));
              },
              style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset('images/stock.png')),
            ),
          ],
        ));
  }
}

class PortfolioCalculate extends StatefulWidget {
  const PortfolioCalculate({Key? key}) : super(key: key);

  @override
  _PortfolioCalculateState createState() => _PortfolioCalculateState();
}

class _PortfolioCalculateState extends State<PortfolioCalculate> {
  late Future<List<UserData>> futureUserData;
  final userDataDB = UserDataDB();

  @override
  void initState() {
    super.initState();
    futureUserData = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final allData = Provider.of<AppData>(context);

    return FutureBuilder(
      future: futureUserData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: ThreeDotWaiting());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Database '));
        } else {
          final datas = snapshot.data!;
          final allCoins = allData.allCoins;
          final allStocks = allData.allStocks;

          if (allCoins.isEmpty || allStocks['actives']!.isEmpty) {
            return Center(
                child: Column(
              children: [
                const Text('Portfolio Balance'),
                Calculating(),
              ],
            ));
          } else {
            List<num> currentBalance =
                calculateCurrentBalance(datas, allCoins, allStocks);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Portfolio Balance'),
                const SizedBox(height: 10),
                Text(
                  '\$${NumberFormat().format(currentBalance[0])}',
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                ),
                lost(currentBalance),
                const SizedBox(height: 15),
                trade(),
              ],
            );
          }
        }
      },
    );
  }

  Widget lost(List<num> temp) {
    final precentage = ((temp[0] - temp[1]) / temp[1]) * 100;
    return Row(
      children: [
        const Spacer(),
        Icon(
          precentage > 0
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded,
          color: precentage > 0 ? Colors.greenAccent : Colors.redAccent,
        ),
        Text(
          '${precentage.toStringAsFixed(2)}%',
          style: TextStyle(
              color: precentage > 0 ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 17),
        ),
        const Spacer()
      ],
    );
  }

  Widget trade() {
    return Container(
        alignment: Alignment.center,
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
                child: Column(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25)),
                        child:
                            const Icon(Icons.swap_horiz, color: Colors.black))),
                const Text('Trade')
              ],
            )),
            Expanded(
                child: Column(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25)),
                        child:
                            const Icon(Icons.swap_vert, color: Colors.white))),
                const Text('Deposite')
              ],
            )),
            Expanded(
                child: Column(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25)),
                        child: const Icon(Icons.arrow_downward_rounded,
                            color: Colors.black))),
                const Text('Withdraw')
              ],
            )),
          ],
        ));
  }

  Future<List<UserData>> fetchUserData() async {
    await userDataDB.initializeDB();
    return await userDataDB.fetchUserData();
  }

  List<num> calculateCurrentBalance(
      List<UserData> datas,
      Map<String, CoinModel> allCoins,
      Map<String, Map<String, StockData>> allStocks) {
    num secondIndex = 0, firstIndex = 0;
    for (final userData in datas) {
      final currentTradeVal =
          calculateCurrentTradeValue(userData, allCoins, allStocks);
      firstIndex += currentTradeVal * userData.investment;
      secondIndex += userData.history
          .map((e) => e[1])
          .fold(0, (prev, value) => prev + value);
    }
    return [firstIndex, secondIndex];
  }

  num calculateCurrentTradeValue(
      UserData userData,
      Map<String, CoinModel> allCoins,
      Map<String, Map<String, StockData>> allStocks) {
    if (userData.isCoin == 1) {
      return allCoins[userData.id]!.currentPrice;
    } else {
      final stock = allStocks['actives']![userData.id] ??
          allStocks['gainers']![userData.id] ??
          allStocks['losers']![userData.id];
      if (stock != null) {
        print('stock - ${stock}');
      } else {
        print('history ${userData.history}');
      }
      return stock != null
          ? double.parse(stock.price)
          : userData.history.last[1];
    }
  }
}

class FavoriteCoins extends StatefulWidget {
  final Size size;
  const FavoriteCoins({Key? key, required this.size}) : super(key: key);
  @override
  State<FavoriteCoins> createState() => _FavoriteCoinsState();
}

class _FavoriteCoinsState extends State<FavoriteCoins> {
  List<String> coins = [
    'bitcoin',
    'ethereum',
    'tether',
    'binancecoin',
    'ripple',
    'usd-coin',
    'staked-ether',
    'solana',
    'cardano',
    'dogecoin',
    'tron',
    'the-open-network',
    'chainlink'
  ];

  // late Future<List<CoinModel>> futureCoins;
  // @override
  // void initState() {
  //   super.initState();
  //   futureCoins = fetchCoinsDB();
  // }

  @override
  Widget build(BuildContext context) {
    final allData = Provider.of<AppData>(context);

    if (allData.allCoins.isEmpty) {
      return const Center(child: ThreeDotWaiting());
    } else {
      Map<String, CoinModel> allCoins = allData.allCoins;
      final coinModel = coins.map((e) => allCoins[e]!).toList();
      return Container(
          height: 210,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: coinModel.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    coinGesture(coinModel[index]),
                    SizedBox(width: 20),
                  ],
                );
              }));
    }
  }

  Widget coinGesture(CoinModel coin) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CoinDetail(coinModel: coin)));
      },
      child: Container(
          width: 160,
          height: 200,
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 10, left: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Image.network(
                    coin.image,
                    width: 50,
                    height: 50,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Image.asset('images/blockchain.png');
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Image.asset('images/blockchain.png');
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(coin.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 5),
                Text('\$${coin.currentPrice}')
              ],
            ),
          )),
    );
  }

  Future<List<CoinModel>> fetchCoinsDB() async {
    return await ManageCoinDB.fetchCoinDB();
  }
}

class FavoriteStacks extends StatefulWidget {
  final Size size;
  const FavoriteStacks({Key? key, required this.size}) : super(key: key);
  @override
  State<FavoriteStacks> createState() => _FavoriteStacksState();
}

class _FavoriteStacksState extends State<FavoriteStacks> {
  final List<String> ids = [
    'AMZN',
    'TSLA',
    'INTS',
    'PLTR',
    'F',
    'NVDA',
    'SOFI',
    'AAPL',
    'MSFT',
    'SHEL',
    'META',
    'NFLX',
    'BABA',
    'NVR',
    'SPOT',
    'PYPL',
    'GOOGL',
    'UPWK',
    'HPQ',
    'ORCL'
  ];
  late Future<List<GroupedDaily2>> futureFavoriteStocks;
  StockDatabase stockDatabase = StockDatabase();
  late Future<List<Map<String, dynamic>>> future;

  @override
  void initState() {
    super.initState();
    future = fetchFavoriteStockMap();
  }

  @override
  Widget build(BuildContext context) {
    final allData = Provider.of<AppData>(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      width: widget.size.width,
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                  width: 50, height: 30, child: ThreeDotWaiting());
            } else if (snapshot.hasError) {
              return const Text(
                  'Sorry no data or error while fetching the data');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Map<String, dynamic>> groupedDaily2 = snapshot.data!;
              return ListView.builder(
                  itemCount: groupedDaily2.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        buildItemWithGesture(groupedDaily2[index]),
                        const SizedBox(width: 10)
                      ],
                    );
                  });
            }
          }),
    );
  }

  Widget buildItemWithGesture(Map<String, dynamic> stock) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailedView(ticker: stock['Symbol'])));
      },
      child: Container(
          width: 150,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200, width: 1)),
          child: ListTile(
            subtitle: Text('${stock['Name']}',
                style: const TextStyle(color: Colors.black)),
            title: Text('${stock['Symbol']}',
                style: const TextStyle(color: Colors.black)),
            // trailing: Text('${stock['Country']}'),
          )),
    );
  }

  Future<List<Map<String, dynamic>>> fetchFavoriteStockMap() async {
    await stockDatabase.initializeDb();
    return await stockDatabase.fetchFavoriteStocksMap(ids);
  }
}
