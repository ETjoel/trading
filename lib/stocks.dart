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


class Stocks {
  String apiKey = 'qpgWo6vpuNNywLzVTbvgBtkd7Dd4obqt';
  String baseUrl = 'https://api.polygon.io/v2/aggs/';
  Map<String, String> header = {
  'Authorization' : 'Bearer qpgWo6vpuNNywLzVTbvgBtkd7Dd4obqt'
  };

  Future<Aggregates> getAggregates(AggregateParameters parameters) async {
    try {
      var response = await http.get(
          Uri.parse(
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
  Future<IntraDay> getIntradayStock(String type, String symbol) async{
    const api = 'MVO0ISV4UYL330PP';
    String url = '';
    String key = '';
    switch (type) {
      case '1D':
        key = 'Time Series (5min)';
        url = 'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$api';
        break;
      case '5D':
        key = 'Time Series (60min)';
        url = 'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=60min&apikey=$api';
        break;
      case 'Month':
        key = 'Time Series (60min)';
        url = 'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=60min&outputsize=full&apikey=$api';
        break;
      case '6Month':
        key = "Time Series (Daily)";
        url = 'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$api';
      case '20year':
        key = 'Monthly Time Series';
        url = 'https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=$symbol&apikey=$api';
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
      var response =  await http.get(
          Uri.parse(
              'https://api.polygon.io/v2/aggs/grouped/locale/us/market/stocks/$date?adjusted=true&apiKey=qpgWo6vpuNNywLzVTbvgBtkd7Dd4obqt'
          )
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> temp = jsonDecode(response.body);
        if (kDebugMode) {
          print(temp['results'][0]);
        }
        List<dynamic> temp2 =  temp['results'];
        List<GroupedDaily2> resultResults = temp2
            .map((dynamic item) => GroupedDaily2.fromJson(item))
            .toList();
        return resultResults; // Return the parsed Aggregates object
      } else {
        debugPrint("Well, the response error is: ${response.statusCode}");
        throw Exception('Failed to fetch data');
      }
    }
    catch (exception) {
      debugPrint("Error from getGrouped with error: $exception");
      throw Exception('Failed to fetch data');
    }
  }

  Future<StockDetail> fetchStockDetail(String symbol) async {
    const api = 'MVO0ISV4UYL330PP';
    final url = 'https://www.alphavantage.co/query?function=OVERVIEW&symbol=$symbol&apikey=$api';
    print(url);
    final response = await http.get(
      Uri.parse(url)
    );
    if (response.statusCode == 200) {
      final temp = jsonDecode(response.body);
      return StockDetail.fromJson(temp);
    } else {
      throw Exception('error from fetchStockDetail');
    }
  }
}
