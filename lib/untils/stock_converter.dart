//이 파일은 나중에 분리해서 사용.(우선은 watchlist_scree.dart에서 계산)

import '../models/realtime_stock_dto.dart';
import '../models/stock.dart';

Stock convertToStock(
  RealtimeStockDto data, {
  required String stockName,
  required String market,
}) {
  final changeAmount = data.currentPrice - data.previousClose;
  final changeRate = (changeAmount / data.previousClose) * 100;
  return Stock(
    stockName: stockName,
    stockCode: data.symbol,
    market: market,
    currentPrice: data.currentPrice,
    changeAmount: changeAmount,
    changeRate: changeRate,
    openPrice: data.openPrice,
    highPrice: data.highPrice,
    lowPrice: data.lowPrice,
    volume: data.volume,
  );
}
