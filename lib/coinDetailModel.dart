import 'dart:convert';

import 'package:http/http.dart' as http;

class CoinMarketChart {
  List<dynamic> prices;
  List<dynamic> market_caps;
  List<dynamic> total_volumes;
  CoinMarketChart(this.prices, this.market_caps, this.total_volumes);
  factory CoinMarketChart.fromJson(Map<String, dynamic> json) {
    return CoinMarketChart(
      json['prices'],
      json['market_caps'],
      json['total_volumes']
    );
  }
}


class CoinMarketChartModel {
  Future<CoinMarketChart> fetchCoinMarketChart(String id, String days) async {
    final response = await http.get(
      Uri.parse('https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=$days')
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(response.body);
      print(' from CoinMarketChartModel.fetchCoinMarketChart: ${temp['prices'].length}');
      return CoinMarketChart.fromJson(temp);
    }
    else {
      throw Exception('failed from CoinMarketChartModel');
    }
  }
  
  Future<Map<String, dynamic>> fetchCoinDetail(String id) async {
    final response = await http.get(
      Uri.parse('https://api.coingecko.com/api/v3/coins/$id?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false')
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(response.body);
      print('success in getting the datas');
      return {
        'id' : temp['id'],
        'description' : temp['description']['en'],
        'homepage' : temp['links']['homepage'].toString(),
        'image' : temp['image'].toString()
      };
    } else {
      throw Exception('error from fetchCoinDetail func');
    }
  }
  Future<num> getCurrentPrice(String id) async{
    final response = await http.get(
      Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=$id&vs_currencies=usd')
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(response.body);
      return temp[id]['usd'];
    } else {
      throw Exception('error from getCurrentPrice');
    }

  }

}
