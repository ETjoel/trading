import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_json.dart';

class Coins {
  Future<List<CoinModel>> getCoins() async {
    String url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        final List<CoinModel> responseData =
            jsonList.map((json) => CoinModel.fromJson(json)).toList();
        return responseData;
      } else {
        print('failed from getCoins: statusCode: ${response.statusCode}');
        throw Exception('fetal error in getCoins');
      }
    } catch (exception) {
      throw Exception('fetal error in getCoins');
    }
  }
}
