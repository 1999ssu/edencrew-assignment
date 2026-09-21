class SearchStock {
  final String id;
  final String stockCode;
  final String stockName;
  final String market;
  const SearchStock({
    required this.id,
    required this.stockCode,
    required this.stockName,
    required this.market,
  });

  factory SearchStock.fromJson(Map<String, dynamic> json) {
    final symbol = json['code'] as String;
    return SearchStock(
      id: 'domestic:$symbol',
      stockCode: symbol,
      stockName: json['name'] as String,
      market: json['typeName'] as String,
    );
  }
}
