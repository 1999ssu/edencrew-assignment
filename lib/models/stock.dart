class Stock {
  final String stockName;
  final String stockCode;
  final String market;
  final int currentPrice;
  final int changeAmount;
  final double changeRate;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int volume;

  const Stock({
    required this.stockName,
    required this.stockCode,
    required this.market,
    required this.currentPrice,
    required this.changeAmount,
    required this.changeRate,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
  });
}
