import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock/api_json.dart';
import 'package:stock/database.dart';
import 'package:stock/three_dot_waiting.dart';
import 'package:stock/user_data.dart';
import 'coinDetailModel.dart';
//import 'package:waiting_animation/three_dot_waiting.dart';

class CoinDetail extends StatefulWidget {
  final CoinModel coinModel;
  const CoinDetail({Key? key, required this.coinModel}) : super(key: key);

  @override
  State<CoinDetail> createState() => _CoinDetailState();
}

class _CoinDetailState extends State<CoinDetail> {
  CoinMarketChartModel coinMarketChartModel = CoinMarketChartModel();
  UserDataDB userDataDB = UserDataDB();
  late Future<CoinMarketChart> futureCoinMarketChart;
  late Future<Map<String, dynamic>> futureCoinDetail;
  late Future<num> currentPrice;
  String? selectedSegment = '1D';
  double coin = 0;
  final TextEditingController _constroller = TextEditingController();
  final StreamController<num> streamController =
      StreamController<num>.broadcast();

  final Map<String, Widget> segmentedItems = {
    '1D': const Text('1D'),
    '5D': const Text('5D'),
    '1M': const Text('1M'),
    '6M': const Text('6M'),
    '1Yr': const Text('1Yr'),
    'since': const Text('Since'),
  };

  @override
  void initState() {
    super.initState();
    futureCoinMarketChart = fetchCoinDetailFuture('1');
    futureCoinDetail = fetchCoinDetailDBFuture(widget.coinModel.id);
    instantiateCurrentPrice();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.coinModel.name),
          // automaticallyImplyLeading: false,
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //         dispose();
          //       },
          //       icon: const Icon(Icons.arrow_back)),
          //   const Spacer()
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              graphControl(),
              const SizedBox(height: 3),
              coinGraph(),
              coinDetail(),
              exchangeCoin()
            ],
          ),
        ));
  }

  Widget graphControl() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CupertinoSegmentedControl<String>(
          children: segmentedItems,
          groupValue: selectedSegment,
          onValueChanged: (String newValue) {
            setState(() {
              selectedSegment = newValue;
              if (selectedSegment != null) {
                // _setState(selectedSegment!);
              }
            });
          }),
    );
  }

  Widget coinGraph() {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<CoinMarketChart>(
            future: futureCoinMarketChart,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.prices.isEmpty) {
                return const Text('No data in the Database');
              } else {
                print('item length: ${snapshot.data!.prices.length}');
                List<dynamic>? prices = snapshot.data!.prices.reversed.toList();
                double? minX = prices
                    .map((item) => item[0].toDouble())
                    .reduce((min, value) => min < value ? min : value);
                double? maxX = prices
                    .map((item) => item[0].toDouble())
                    .reduce((max, value) => max > value ? max : value);
                double? minY = prices
                    .map((item) => item[1])
                    .reduce((min, value) => min < value ? min : value);
                double? maxY = prices
                    .map((item) => item[1])
                    .reduce((max, value) => max > value ? max : value);
                return Stack(children: [
                  lineChart(prices, minX, maxX, minY, maxY),
                  lineChartY(minX, maxX, minY, maxY)
                ]);
              }
            }));
  }

  Widget lineChart(List<dynamic> prices, double? minX, double? maxX,
      double? minY, double? maxY) {
    List<FlSpot> spots = prices
        .asMap()
        .entries
        .where((entry) => entry.value[1] != null)
        .map((entry) =>
            FlSpot(entry.value[0].toDouble(), entry.value[1].toDouble()))
        .toList();
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineTouchData: graphTouchData(),
        borderData: FlBorderData(
          show: false,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
        minX: minX?.toDouble(),
        maxX: maxX?.toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget lineChartY(double? minX, double? maxX, double? minY, double? maxY) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${maxY?.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.grey.withOpacity(0.5)),
        ),
        const Spacer(),
        Text(
          (minY! + (maxY! - minY) / 2).toStringAsFixed(2),
          style: TextStyle(color: Colors.grey.withOpacity(0.5)),
        ),
        const Spacer(),
        Text(
          minY.toStringAsFixed(2),
          style: TextStyle(color: Colors.grey.withOpacity(0.5)),
        ),
      ],
    );
  }

  LineTouchData graphTouchData() {
    return LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blue,
            getTooltipItems: (List<LineBarSpot> touchedSpot) {
              return touchedSpot.map((LineBarSpot spot) {
                final yValue = spot.y.toStringAsFixed(2);
                final xValue =
                    DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                return LineTooltipItem(
                    yValue,
                    const TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                    children: [
                      const TextSpan(text: '\n'),
                      TextSpan(text: '$xValue')
                    ]);
              }).toList();
            }));
  }

  Widget coinDetail() {
    return FutureBuilder<Map<String, dynamic>>(
        future: futureCoinDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data in the Database');
          } else {
            Map<String, dynamic> data = snapshot.data!;
            return Card(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                    leading: Image.network(widget.coinModel.image),
                    title: Text(widget.coinModel.symbol),
                    subtitle: Text(widget.coinModel.name),
                    trailing: StreamBuilder(
                      stream: streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text('${snapshot.data!}');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              width: 30, height: 10, child: ThreeDotWaiting());
                        } else {
                          return Text(
                              widget.coinModel.currentPrice.toStringAsFixed(2));
                        }
                      },
                    )),
                SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: SingleChildScrollView(
                        child: Text(editedText(data['description']))))
              ],
            ));
          }
        });
  }

  Widget exchangeCoin() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('\$'),
          SizedBox(height: 50, width: 50, child: coinPriceTextField())
        ],
      ),
      StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pri = snapshot.data! ?? 1.0;
            return ElevatedButton(
                onPressed: () async {
                  UserData userData = UserData(
                      widget.coinModel.id,
                      1,
                      [
                        [DateTime.now().millisecondsSinceEpoch, coin]
                      ],
                      coin / pri);
                  await userDataDB.insertUserDataDb(userData);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child: Text(
                    'Buy ${coin / pri} ${widget.coinModel.name} at \$$pri'));
          } else {
            return Container(
              width: 100,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: const SizedBox(
                  width: 30, height: 10, child: ThreeDotWaiting()),
            );
          }
        },
      ),
    ]);
  }

  Widget coinPriceTextField() {
    return TextField(
      controller: _constroller,
      autocorrect: false,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(hintText: '0'),
      onChanged: (text) {
        if (RegExp(r'^[0-9.]+$').hasMatch(text) && text[0] != '0') {
          setState(() => coin = double.parse(text));
        }
      },
    );
  }

  void _setState(String selectedValue) {
    String days = '1';
    switch (selectedValue) {
      case '1D':
        days = '1';
        print(days);
        break;
      case '5D':
        days = '5';
        print(days);
        break;
      case '1M':
        days = '30';
        print(days);
        break;
      case '6M':
        days = '180';
        print(days);
        break;
      case '1Yr':
        days = '365';
        print(days);
        break;
      case 'since':
        days = 'max';
        print(days);
        break;
    }
    futureCoinMarketChart = fetchCoinDetailFuture(days);
  }

  Future<CoinMarketChart> fetchCoinDetailFuture(String days) async {
    return await coinMarketChartModel.fetchCoinMarketChart(
        widget.coinModel.id, days);
  }

  Future<Map<String, dynamic>> fetchCoinDetailDBFuture(String id) async {
    final temp = await ManageCoinDB.fetchCoinDetailDB(id);
    if (temp.isEmpty) {
      Map<String, dynamic> temp2 =
          await coinMarketChartModel.fetchCoinDetail(id);
      await ManageCoinDB.insertCoinsDetail(temp2);
      return temp2;
    } else {
      return temp[0];
    }
  }

  String editedText(String detail) {
    RegExp reg = RegExp(r'<a[^>]*>.*?<\/a>');
    RegExp reg2 = RegExp(r'>.*?<');
    RegExp url = RegExp(r'\".*?\"');
    String result = detail.replaceAllMapped(reg, (match) {
      List<Match> word = reg2.allMatches('${match.group(0)}').toList();
      List<Match> links = url.allMatches('${match.group(0)}').toList();
      if (word.isNotEmpty && links.isNotEmpty) {
        String link = word[0].group(0) ?? '> <';
        String url = links[0].group(0) ?? '';
        return '${link.substring(1, link.length - 1)}($url)';
      } else {
        return '';
      }
    });
    return result;
  }

  Future<void> instantiateCurrentPrice() async {
    currentPrice = coinMarketChartModel.getCurrentPrice(widget.coinModel.id);
    streamController.add(await currentPrice);
  }
}
