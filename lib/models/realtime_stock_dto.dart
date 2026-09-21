class RealtimeStockDto {
  final String symbol;
  final int currentPrice;
  final int previousClose;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int volume;
  final int listedStockCount;

  const RealtimeStockDto({
    required this.symbol,
    required this.currentPrice,
    required this.previousClose,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.listedStockCount,
  });

  factory RealtimeStockDto.fromJson(Map<String, dynamic> json) {
    return RealtimeStockDto(
      symbol: json['cd'] as String,
      currentPrice: json['nv'] as int,
      previousClose: json['pcv'] as int,
      openPrice: json['ov'] as int,
      highPrice: json['hv'] as int,
      lowPrice: json['lv'] as int,
      volume: json['aq'] as int,
      listedStockCount: json['countOfListedStock'] as int,
    );
  }
}
