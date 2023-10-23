import 'dart:convert';

import 'package:flutter/foundation.dart';

class Aggregates {
  String ticker;
  int queryCount;
  int resultsCount;
  bool adjusted;
  List<Aggregates2> results;
  String status;
  String requestId;

  Aggregates(this.ticker, this.queryCount, this.resultsCount, this.adjusted,
      this.results, this.status, this.requestId);

  factory Aggregates.fromJson(Map<String, dynamic> json) {
    List<Aggregates2> resultsList = (json['results'] as List)
        .map((resultJson) => Aggregates2.fromJson(resultJson))
        .toList();
    return Aggregates(
      json['ticker'],
      json['queryCount'],
      json['resultsCount'],
      json['adjusted'],
      resultsList,
      json['status'],
      json['request_id'],
    );
  }
}

class Aggregates2 {
  num? v;
  num? vw;
  num? o;
  num? c;
  num? h;
  num? l;
  num? t;
  num? n;

  Aggregates2(this.v, this.vw, this.o, this.c, this.h, this.l, this.t, this.n);
  factory Aggregates2.fromJson(Map<String, dynamic> json) {
    return Aggregates2(
      json['v'],
      json['vw'],
      json['o'],
      json['c'],
      json['h'],
      json['l'],
      json['t'],
      json['n'],
    );
  }
}

class GroupedDaily {
  bool adjusted;
  int queryCount;
  List<GroupedDaily2> results;
  int resultsCount;
  String status;

  GroupedDaily({
    required this.adjusted,
    required this.queryCount,
    required this.results,
    required this.resultsCount,
    required this.status,
  });

  factory GroupedDaily.fromJson(Map<String, dynamic> json) {
    List<dynamic> resultsList = json['results'];
    List<GroupedDaily2> parsedResults = resultsList
        .map((resultJson) => GroupedDaily2.fromJson(resultJson))
        .toList();

    return GroupedDaily(
      adjusted: json['adjusted'],
      queryCount: json['queryCount'],
      results: parsedResults,
      resultsCount: json['resultsCount'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adjusted': adjusted,
      'queryCount': queryCount,
      'results': results.map((result) => result.toJson()).toList(),
      'resultsCount': resultsCount,
      'status': status,
    };
  }
}

class IntraDay {
  List<Map<String, TimeSeriesData>> timeSeriesData;

  IntraDay(this.timeSeriesData);
  factory IntraDay.fromJson(Map<String, dynamic> json) {
    List<Map<String, TimeSeriesData>> data = [];
    json.forEach((key, value) {
      data.add({key: TimeSeriesData.fromJson(value)});
    });
    return IntraDay(data);
  }
}

class TimeSeriesData {
  String open;
  String high;
  String low;
  String close;
  String volume;

  TimeSeriesData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) {
    return TimeSeriesData(
      open: json['1. open'],
      high: json['2. high'],
      low: json['3. low'],
      close: json['4. close'],
      volume: json['5. volume'],
    );
  }
}

class GroupedDaily2 {
  String ticker;
  num? c;
  num? h;
  num? l;
  num? n;
  num? o;
  num? t;
  num? v;
  num? vw;

  GroupedDaily2({
    required this.ticker,
    required this.c,
    required this.h,
    required this.l,
    required this.n,
    required this.o,
    required this.t,
    required this.v,
    required this.vw,
  });

  factory GroupedDaily2.fromJson(Map<String, dynamic> json) {
    return GroupedDaily2(
      ticker: json['T'],
      c: json['c'],
      h: json['h'],
      l: json['l'],
      n: json['n'],
      o: json['o'],
      t: json['t'],
      v: json['v'],
      vw: json['vw'],
    );
  }
  factory GroupedDaily2.fromMap(Map<String, dynamic> json) {
    return GroupedDaily2(
      ticker: json['ticker'],
      c: json['c'],
      h: json['h'],
      l: json['l'],
      n: json['n'],
      o: json['o'],
      t: json['t'],
      v: json['v'],
      vw: json['vw'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'c': c,
      'h': h,
      'l': l,
      'n': n,
      'o': o,
      't': t,
      'v': v,
      'vw': vw,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'c': c,
      'h': h,
      'l': l,
      'n': n,
      'o': o,
      't': t,
      'v': v,
      'vw': vw,
    };
  }

  @override
  String toString() {
    return 'GroupedDaily2(ticker: $ticker, c: $c, h: $h, l: $l, n: $n, o: $o, t: $t, v: $v, vw: $vw';
  }
}

class StockDetail {
  String symbol;
  String assetType;
  String name;
  String description;
  String exchange;
  String currency;
  String country;
  String sector;
  String industry;
  String address;

  StockDetail(
      this.symbol,
      this.assetType,
      this.name,
      this.description,
      this.exchange,
      this.currency,
      this.country,
      this.sector,
      this.industry,
      this.address);
  factory StockDetail.fromJson(Map<String, dynamic> json) {
    return StockDetail(
        json['Symbol'],
        json['AssetType'],
        json['Name'],
        json['Description'],
        json['Exchange'],
        json['Currency'],
        json['Country'],
        json['Sector'],
        json['Industry'],
        json['Address']);
  }

  Map<String, dynamic> toMap(StockDetail stockDetail) {
    return {
      'Symbol': stockDetail.symbol,
      'AssetType': stockDetail.assetType,
      'Name': stockDetail.name,
      'Description': stockDetail.description,
      'Exchange': stockDetail.exchange,
      'Currency': stockDetail.currency,
      'Country': stockDetail.country,
      'Sector': stockDetail.sector,
      'Industry': stockDetail.industry,
      'Address': stockDetail.address
    };
  }
}

class CoinModel {
  String id, symbol, name;
  String image;
  double currentPrice;
  double? marketCap, marketCapRank, fullyDilutedValuation;
  double? totalVolume, high24H, low24H;
  double? priceChange24H;
  double? priceChangePercentage24H;
  double? marketCapChange24H;
  double? marketCapChangePercentage24H;
  double? circulatingSupply, totalSupply, maxSupply, ath;
  double? athChangePercentage;
  String? athDate;
  double? atl, atlChangePercentage;
  String? atlDate;
  String? lastUpdated;
  List<double>? price;
  double? priceChangePercentage24HInCurrency;
  double? currentHoldings;

  CoinModel(
      this.id,
      this.symbol,
      this.name,
      this.image,
      this.currentPrice,
      this.marketCap,
      this.marketCapRank,
      this.fullyDilutedValuation,
      this.totalVolume,
      this.high24H,
      this.low24H,
      this.priceChange24H,
      this.priceChangePercentage24H,
      this.marketCapChange24H,
      this.marketCapChangePercentage24H,
      this.circulatingSupply,
      this.totalSupply,
      this.maxSupply,
      this.ath,
      this.athChangePercentage,
      this.athDate,
      this.atl,
      this.atlChangePercentage,
      this.atlDate,
      this.lastUpdated,
      this.price,
      this.priceChangePercentage24HInCurrency);
  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
        json['id'],
        json['symbol'],
        json['name'],
        json['image'],
        json['current_price'].toDouble(),
        json['market_cap']?.toDouble(),
        json['market_cap_rank']?.toDouble(),
        json['fully_diluted_valuation']?.toDouble(),
        json['total_volume']?.toDouble(),
        json['high_24h']?.toDouble(),
        json['low_24h']?.toDouble(),
        json['price_change_24h']?.toDouble(),
        json['price_change_percentage_24h']?.toDouble(),
        json['market_cap_change_24h']?.toDouble(),
        json['market_cap_change_percentage_24h']?.toDouble(),
        json['circulating_supply']?.toDouble(),
        json['total_supply']?.toDouble(),
        json['max_supply']?.toDouble(),
        json['ath']?.toDouble(),
        json['ath_change_percentage']?.toDouble(),
        json['ath_date'],
        json['atl']?.toDouble(),
        json['atl_change_percentage']?.toDouble(),
        json['atl_date'],
        json['last_updated'],
        (json['sparkline_in_7d']['price'] as List<dynamic>?)
            ?.map((e) => e.toDouble())
            .cast<double>()
            .toList(),
        json['price_change_percentage_24h_in_currency']?.toDouble());
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'fully_diluted_valuation': fullyDilutedValuation,
      'total_volume': totalVolume,
      'high_24h': high24H,
      'low_24h': low24H,
      'price_change_24h': priceChange24H,
      'price_change_percentage_24h': priceChangePercentage24H,
      'market_cap_change_24h': marketCapChange24H,
      'market_cap_change_percentage_24h': marketCapChangePercentage24H,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'ath': ath,
      'ath_change_percentage': athChangePercentage,
      'ath_date': athDate,
      'atl': atl,
      'atl_change_percentage': atlChangePercentage,
      'atl_date': atlDate,
      'last_updated': lastUpdated,
      'price': jsonEncode(price),
      'price_change_percentage_24h_in_currency':
          priceChangePercentage24HInCurrency,
    };
  }

  Map<String, dynamic> toUpdatedMap() {
    return {
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'fully_diluted_valuation': fullyDilutedValuation,
      'total_volume': totalVolume,
      'high_24h': high24H,
      'low_24h': low24H,
      'price_change_24h': priceChange24H,
      'price_change_percentage_24h': priceChangePercentage24H,
      'market_cap_change_24h': marketCapChange24H,
      'market_cap_change_percentage_24h': marketCapChangePercentage24H,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'ath': ath,
      'ath_change_percentage': athChangePercentage,
      'ath_date': athDate,
      'atl': atl,
      'atl_change_percentage': atlChangePercentage,
      'atl_date': atlDate,
      'last_updated': lastUpdated,
      'price': jsonEncode(price),
      'price_change_percentage_24h_in_currency':
          priceChangePercentage24HInCurrency,
    };
  }

  factory CoinModel.fromMap(Map<String, dynamic> json) {
    return CoinModel(
        json['id'],
        json['symbol'],
        json['name'],
        json['image'],
        json['current_price'].toDouble(),
        json['market_cap']?.toDouble(),
        json['market_cap_rank']?.toDouble(),
        json['fully_diluted_valuation']?.toDouble(),
        json['total_volume']?.toDouble(),
        json['high_24h']?.toDouble(),
        json['low_24h']?.toDouble(),
        json['price_change_24h']?.toDouble(),
        json['price_change_percentage_24h']?.toDouble(),
        json['market_cap_change_24h']?.toDouble(),
        json['market_cap_change_percentage_24h']?.toDouble(),
        json['circulating_supply']?.toDouble(),
        json['total_supply']?.toDouble(),
        json['max_supply']?.toDouble(),
        json['ath']?.toDouble(),
        json['ath_change_percentage']?.toDouble(),
        json['ath_date'],
        json['atl']?.toDouble(),
        json['atl_change_percentage']?.toDouble(),
        json['atl_date'],
        json['last_updated'],
        jsonDecode(json['price'])
            ?.map((e) => e.toDouble())
            .cast<double>()
            .toList(),
        json['price_change_percentage_24h_in_currency']?.toDouble());
  }
}

class CoinModelDetail {
  String? id, symbol, name;
  int? blockTimeInMinutes;
  String? hashingAlgorithm;
  String? description;
  List<String>? homepage;
  String? subredditURL;

  CoinModelDetail(
      this.id,
      this.symbol,
      this.name,
      this.blockTimeInMinutes,
      this.hashingAlgorithm,
      this.description,
      this.homepage,
      this.subredditURL);

  factory CoinModelDetail.fromJson(Map<String, dynamic> json) {
    return CoinModelDetail(
      json['id'],
      json['symbol'],
      json['name'],
      json['block_time_in_minutes']?.toInt(),
      json['hashing_algorithm'],
      json['description']['en'],
      (json['homepage'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      json['subreddit_url'],
    );
  }
}
