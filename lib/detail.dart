import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock/stock_database.dart';
import 'package:stock/stocks.dart';

import 'api_json.dart';

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
    // AggregateParameters parameters = AggregateParameters(widget.item.ticker, '1', 'minute', timeWindow, timeWindow, 'true', 'asc', '30');
    // futureData = fetchData(parameters);
    // futureResult = fetchResults(futureData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.ticker)
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            graphControl(),
            stockDetail(),
            stockDetailView()
          ],
        ),
      )
    );
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
          }
      ),
    );
  }

  Widget stockDetail() {
    return Padding(
      padding: EdgeInsets.all(5),
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
                        child:  CircularProgressIndicator()
                    );
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
                    num _minY = values.map((e) => e[1]).reduce((min, value) => min < value ? min : value);
                    num _maxY = values.map((e) => e[1]).reduce((max, value) => max > value ? max : value);
                    num _midY = ((_maxY - _minY) / 2) + _minY;
                    double _minX = values[values.length - 1][0].toDouble();
                    double _maxX = values[0][0].toDouble();
                    List<FlSpot> _spots = values
                        .asMap()
                        .entries
                        .where((entry) => entry.value[1] != null)
                        .map((entry) => FlSpot(entry.value[0].toDouble(), entry.value[1].toDouble()))
                        .toList();
                    return Stack(
                      children: [
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
                                  final xValue = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                                  return LineTooltipItem(
                                    yValue,
                                    TextStyle(
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

                          minX: values[values.length - 1][0].toDouble() ,
                          maxX: values[0][0].toDouble(),
                          minY: _minY.roundToDouble(),
                          maxY: _maxY.roundToDouble(),
                          lineBarsData: [
                            LineChartBarData(
                                spots: _spots,
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
                            Text('$_maxY'),
                            Spacer(),
                            Text('$_midY'),
                            Spacer(),
                            Text('$_minY'),
                          ],
                        ),
                  ]
                    );
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
    return FutureBuilder<StockDetail> (
      future: futureStockDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              width: 50,
              height: 50,
              child:  CircularProgressIndicator()
          );
        } else if (snapshot.hasError) {
          return Text('No Data on this stock');
        } else if (!snapshot.hasData) {
          return Text('No Data on this stock');
        } else {
          StockDetail data = snapshot.data!;
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text('${data.symbol}'),
                  subtitle: Text('${data.name}'),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${data.country}'),
                      // Text('${data.address}')
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  child: SingleChildScrollView(child: Text('${data.description}'))
                )
              ],
            )
          );
        }
      }
    );
  }
  void _setState(String selectedValue) {
    // DateTime temp = dateTime.subtract(const Duration(days: 2));
    //       String to = '${temp.year}-${temp.month.toString().padLeft(2, '0')}-${temp.day.toString().padLeft(2, '0')}';

          // AggregateParameters parameter =  AggregateParameters(widget.item.ticker, '1', 'minute', to, to, 'true', 'asc', '5000');
          // switch (selectedValue) {
          //   case '1D':
          //     // parameter.from = to;
          //     futureIterday = fetchIntraDay('5min');
          //     break;
          //   case '5D':
          //     futureIterday = fetchIntraDay();
          //     // temp = dateTime.subtract(const Duration(days: 7));
          //     // parameter.from =
          //     // '${temp.year}-${temp.month.toString().padLeft(2, '0')}-${temp.day.toString().padLeft(2, '0')}';
          //     // parameter.timespan = 'minute';
          //     // parameter.multiplier = '10';
          //     break;
          //   case '1M':
          //     // temp = dateTime.subtract(const Duration(days: 30));
          //     // parameter.from = '${temp.year}-${temp.month.toString().padLeft(2, '0')}-${temp.day.toString().padLeft(2, '0')}';
          //     // parameter.timespan = 'day';
          //     // parameter.multiplier = '1';
          //     break;
          //   case '6M':
          //     // parameter.from = '${dateTime.year }-${(dateTime.month - 6).toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
          //     // parameter.timespan = 'day';
          //     break;
          //     case '1Yr':
          //       // parameter.from = '${dateTime.year - 1 }-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
          //       // parameter.timespan = 'day';
          //       // parameter.multiplier = '7';
          //       break;
          //   case '2Yr':
          //     // parameter.from = '${dateTime.year - 2}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
          //     // parameter.timespan = 'day';
          //     // parameter.multiplier = '7';
          //     break;
          // }
          // // print(parameter);
          // // futureData = fetchData(parameter);
          // // futureResult = fetchResults(futureData);
    futureIterday = fetchIntraDay(selectedValue);
  }

  // Future<Aggregates> fetchData(AggregateParameters parameters) async {
  //   agg = await stock.getAggregates(parameters);
  //   return agg;
  // }
  Future<IntraDay> fetchIntraDay (String key) async {
    return await stock.getIntradayStock(key, widget.item.ticker);
  }

  Future<List<dynamic>> fetchResults(Future<Aggregates> agg) async {
    try {
      Aggregates aggregates = await agg;
      return aggregates.results;
    }
    catch (error) {
      debugPrint("error from fetchResults $error");
      throw Exception('"error from fetchResults $error"');
    }
  }

  Future<StockDetail> fetchCoinDetail() async {
    await stockDatabase.initializeDb();
    List<StockDetail> stockDetail = await stockDatabase.fetchStockDetailDB(widget.item.ticker);
    if (stockDetail.isEmpty) {
      StockDetail temp = await stock.fetchStockDetail(widget.item.ticker);
        await stockDatabase.insertStockDetail(temp);
        return temp;
    } else {
      return stockDetail[0];
    }
  }
}
