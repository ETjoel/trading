import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'api_json.dart';
import 'package:http/http.dart' as http;

class AggregateParameters {
  String stocksTicker = '';
  String multiplier = '';
  String timespan = '';
  String from = '';
  String to = '';
  String adjust = '';
  String sort = '';
  String limit = '';

  AggregateParameters.named() {
    stocksTicker = '';
    multiplier = '';
    timespan = '';
    from = '';
    to = '';
    adjust = '';
    sort = '';
    limit = '';
  }

  AggregateParameters(this.stocksTicker, this.multiplier, this.timespan,
      this.from, this.to, this.adjust, this.sort, this.limit);
}

class StockList {
  String metadata;
  String lastUpdated;
  List<StockData> topGainers;
  List<StockData> topLosers;
  List<StockData> mostActivelyTraded;

  StockList(
      {required this.metadata,
      required this.lastUpdated,
      required this.topGainers,
      required this.topLosers,
      required this.mostActivelyTraded});

  factory StockList.fromJson(Map<String, dynamic> json) {
    return StockList(
      metadata: json['metadata'],
      lastUpdated: json['last_updated'],
      topGainers: List<StockData>.from(
          json['top_gainers'].map((x) => StockData.fromJson(x))),
      topLosers: List<StockData>.from(
          json['top_losers'].map((x) => StockData.fromJson(x))),
      mostActivelyTraded: List<StockData>.from(
          json['most_actively_traded'].map((x) => StockData.fromJson(x))),
    );
  }
  factory StockList.empty() {
    return StockList(
        metadata: '',
        lastUpdated: '',
        topGainers: [],
        topLosers: [],
        mostActivelyTraded: []);
  }
}

class StockData {
  String ticker;
  String price;
  String changeAmount;
  String changePercentage;
  String volume;

  StockData(
      {required this.ticker,
      required this.price,
      required this.changeAmount,
      required this.changePercentage,
      required this.volume});

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      ticker: json['ticker'],
      price: json['price'],
      changeAmount: json['change_amount'],
      changePercentage: json['change_percentage'],
      volume: json['volume'],
    );
  }
}

class Stocks {
  String apiKey = 'qpgWo6vpuNNywLzVTbvgBtkd7Dd4obqt';
  String baseUrl = 'https://api.polygon.io/v2/aggs/';

  Map<String, String> header = {
    'Authorization': 'Bearer qpgWo6vpuNNywLzVTbvgBtkd7Dd4obqt'
  };

  Future<Aggregates> getAggregates(AggregateParameters parameters) async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.polygon.io/v2/aggs/ticker/${parameters.stocksTicker}/range/${parameters.multiplier}/${parameters.timespan}/${parameters.from}/${parameters.to}?adjusted=true&sort=asc&limit=${parameters.limit}&apiKey=qpgWo6vpuNNywLzVTbvgBtkd7Dd4obqt'));
      if (response.statusCode == 200) {
        Map<String, dynamic> temp = jsonDecode(response.body);
        Aggregates aggregates = Aggregates.fromJson(temp);
        debugPrint("We are successful");
        debugPrint(aggregates.ticker);
        return aggregates; // Return the parsed Aggregates object
      } else {
        debugPrint("Well, the response error is: ${response.statusCode}");
        throw Exception('Failed to fetch data');
      }
    } catch (exception) {
      debugPrint("Error from getAggregates with error: $exception");
      throw Exception('Failed to fetch data');
    }
  }

  Future<IntraDay> getIntradayStock(String type, String symbol) async {
    const api = 'MVO0ISV4UYL330PP';
    String url = '';
    String key = '';
    switch (type) {
      case '1D':
        key = 'Time Series (5min)';
        url =
            'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$api';
        break;
      case '5D':
        key = 'Time Series (60min)';
        url =
            'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=60min&apikey=$api';
        break;
      case 'Month':
        key = 'Time Series (60min)';
        url =
            'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=60min&outputsize=full&apikey=$api';
        break;
      case '6Month':
        key = "Time Series (Daily)";
        url =
            'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$api';
      case '20year':
        key = 'Monthly Time Series';
        url =
            'https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=$symbol&apikey=$api';
        break;
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final timeSeries = jsonDecode(response.body)[key];
      return IntraDay.fromJson(timeSeries);
    } else {
      throw Exception("Couldn't get data from alphsvantage");
    }
  }

  Future<List<GroupedDaily2>> getGrouped(String date) async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.polygon.io/v2/aggs/grouped/locale/us/market/stocks/$date?adjusted=true&apiKey=qpgWo6vpuNNywLzVTbvgBtkd7Dd4obqt'));
      if (response.statusCode == 200) {
        Map<String, dynamic> temp = jsonDecode(response.body);
        if (kDebugMode) {
          print(temp['results'][0]);
        }
        List<dynamic> temp2 = temp['results'];
        List<GroupedDaily2> resultResults =
            temp2.map((dynamic item) => GroupedDaily2.fromJson(item)).toList();
        return resultResults; // Return the parsed Aggregates object
      } else {
        debugPrint("Well, the response error is: ${response.statusCode}");
        throw Exception('Failed to fetch data');
      }
    } catch (exception) {
      debugPrint("Error from getGrouped with error: $exception");
      throw Exception('Failed to fetch data');
    }
  }

  Future<StockDetail> fetchStockDetail(String symbol) async {
    const api = 'MVO0ISV4UYL330PP';
    final url =
        'https://www.alphavantage.co/query?function=OVERVIEW&symbol=$symbol&apikey=$api';
    print(url);

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final temp = jsonDecode(response.body);

        if (temp != null && temp is Map<String, dynamic>) {
          return StockDetail.fromJson(temp);
        } else {
          throw Exception('Error: Response body is not a valid JSON object.');
        }
      } else {
        throw Exception('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<StockList> fetchMostActiveStocks() async {
    const api = 'MVO0ISV4UYL330PP';
    const url =
        'https://www.alphavantage.co/query?function=TOP_GAINERS_LOSERS&apikey=$api';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final temp = jsonDecode(response.body);
      if (temp != null && temp is Map<String, dynamic>) {
        return StockList.fromJson(temp);
      } else {
        return StockList(
            metadata: '',
            lastUpdated: '',
            topGainers: [],
            topLosers: [],
            mostActivelyTraded: []);
      }
    } else {
      return StockList(
          metadata: '',
          lastUpdated: '',
          topGainers: [],
          topLosers: [],
          mostActivelyTraded: []);
    }
  }
}
