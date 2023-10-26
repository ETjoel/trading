import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock/stock_database.dart';
import 'package:stock/stocks.dart';
import 'api_json.dart';
import 'three_dot_waiting.dart';
import 'user_data.dart';

class DetailedView extends StatefulWidget {
  GroupedDaily2 item;
  DetailedView({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  late Aggregates agg;
  String? selectedValue = '1D';
  Stocks stock = Stocks();
  // late Future<Aggregates> futureData;
  // late Future<List<dynamic>> futureResult;
  late Future<IntraDay> futureIterday;
  StockDatabase stockDatabase = StockDatabase();
  late Future<StockDetail> futureStockDetail;
  UserDataDB userDataDB = UserDataDB();
  final StreamController<num> streamController =
      StreamController<num>.broadcast();
  final TextEditingController _controller = TextEditingController();
  double money = 0;

  DateTime dateTime = DateTime.now();
  String selectedSegment = '1D';
  final Map<String, Widget> segmentedItems = {
    '1D': const Text('1D'),
    '5D': const Text('5D'),
    'Month': const Text('Month'),
    '6Month': const Text('6Month'),
    '20year': const Text('20year'),
  };

  @override
  void initState() {
    super.initState();
    String timeWindow;
    DateTime temp = dateTime.subtract(const Duration(days: 2));
    String formattedMonth = temp.month.toString().padLeft(2, '0');
    String formattedDay = temp.day.toString().padLeft(2, '0');
    timeWindow = '${temp.year}-$formattedMonth-$formattedDay';
    futureStockDetail = fetchCoinDetail();
    futureIterday = fetchIntraDay('1D');
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.item.ticker)),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              graphControl(),
              stockDetail(),
              stockDetailView(),
              exchangeStock()
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
              _setState(selectedSegment);
            });
          }),
    );
  }

  Widget stockDetail() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<IntraDay>(
                future: futureIterday,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    IntraDay items = snapshot.data!;
                    List<List<num>> values = items.timeSeriesData.map((item) {
                      List<num> temp = [];
                      for (final key in item.keys) {
                        temp.add(DateTime.parse(key).millisecondsSinceEpoch);
                      }
                      for (final value in item.values) {
                        temp.add(double.parse(value.open));
                      }
                      return temp;
                    }).toList();
                    num minY = values
                        .map((e) => e[1])
                        .reduce((min, value) => min < value ? min : value);
                    num maxY = values
                        .map((e) => e[1])
                        .reduce((max, value) => max > value ? max : value);
                    num midY = ((maxY - minY) / 2) + minY;
                    double minX = values[values.length - 1][0].toDouble();
                    double maxX = values[0][0].toDouble();
                    List<FlSpot> spots = values
                        .asMap()
                        .entries
                        .where((entry) => entry.value[1] != null)
                        .map((entry) => FlSpot(entry.value[0].toDouble(),
                            entry.value[1].toDouble()))
                        .toList();
                    return Stack(children: [
                      LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.blue,
                              getTooltipItems: (List<LineBarSpot> touchSpot) {
                                return touchSpot.map((LineBarSpot spot) {
                                  final yValue = spot.y.toStringAsFixed(2);
                                  final xValue =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          spot.x.toInt());
                                  return LineTooltipItem(
                                    yValue,
                                    const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      const TextSpan(text: '\n'),
                                      TextSpan(text: '$xValue'),
                                    ],
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                            border: Border.all(
                              color: const Color(0xff37434d),
                              width: 1,
                            ),
                          ),
                          minX: values[values.length - 1][0].toDouble(),
                          maxX: values[0][0].toDouble(),
                          minY: minY.roundToDouble(),
                          maxY: maxY.roundToDouble(),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: false,
                              color: Colors.blue,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.3),
                              ),
                              // shadow: const BoxShadow(
                              //     color: Colors.blue,
                              //     offset: Offset(0, 20),
                              //     blurRadius: 5,
                              //     blurStyle: BlurStyle.inner,
                              //     spreadRadius: 20
                              // )
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$maxY'),
                          const Spacer(),
                          Text('$midY'),
                          const Spacer(),
                          Text('$minY'),
                        ],
                      ),
                    ]);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stockDetailView() {
    return FutureBuilder<StockDetail>(
        future: futureStockDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('No Data on this stock');
          } else if (!snapshot.hasData) {
            return const Text('No Data on this stock');
          } else {
            StockDetail data = snapshot.data!;
            return Card(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(data.symbol),
                  subtitle: Text(data.name),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(data.country),
                      // Text('${data.address}')
                    ],
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: SingleChildScrollView(child: Text(data.description)))
              ],
            ));
          }
        });
  }

  Widget exchangeStock() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('\$'),
          SizedBox(height: 50, width: 50, child: stcokPriceTextField())
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
                      widget.item.ticker,
                      0,
                      [
                        [DateTime.now().millisecondsSinceEpoch, money]
                      ],
                      money / pri);
                  await userDataDB.insertUserDataDb(userData);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child:
                    Text('Buy ${money / pri} ${widget.item.ticker} at \$$pri'));
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

  Widget stcokPriceTextField() {
    return TextField(
      controller: _controller,
      autocorrect: false,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(hintText: '0'),
      onChanged: (text) {
        if (RegExp(r'^[0-9.]+$').hasMatch(text) && text[0] != '0') {
          setState(() => money = double.parse(text));
        }
      },
    );
  }

  void _setState(String selectedValue) {
    futureIterday = fetchIntraDay(selectedValue);
  }

  Future<IntraDay> fetchIntraDay(String key) async {
    final temp = await stock.getIntradayStock(key, widget.item.ticker);
    IntraDay stream = await stock.getIntradayStock('1D', widget.item.ticker);
    List<num> values = stream.timeSeriesData[0].values
        .map((e) => double.parse(e.open))
        .toList();
    streamController.add(values[0]);
    return temp;
  }

  Future<List<dynamic>> fetchResults(Future<Aggregates> agg) async {
    try {
      Aggregates aggregates = await agg;
      return aggregates.results;
    } catch (error) {
      debugPrint("error from fetchResults $error");
      throw Exception('"error from fetchResults $error"');
    }
  }

  Future<StockDetail> fetchCoinDetail() async {
    await stockDatabase.initializeDb();
    List<StockDetail> stockDetail =
        await stockDatabase.fetchStockDetailDB(widget.item.ticker);
    if (stockDetail.isEmpty) {
      StockDetail temp = await stock.fetchStockDetail(widget.item.ticker);
      await stockDatabase.insertStockDetail(temp);
      return temp;
    } else {
      return stockDetail[0];
    }
  }
}
