import 'package:edencrew_assignment_starter/widgets/empty_state.dart';
import 'package:edencrew_assignment_starter/widgets/stock_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../services/naver_api_service.dart';
import '../models/realtime_stock_dto.dart';
import '../models/stock.dart';
import '../untils/stock_converter.dart';

class WatchlistScreen extends StatefulWidget {
  final Set<String> favoriteStocks;
  const WatchlistScreen({super.key, required this.favoriteStocks});
  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  int selectedTab = 0;
  final NaverApiService api = NaverApiService();
  final TextEditingController searchController = TextEditingController();

  List<Stock> stocks = [];
  // List<SearchStock> searchResults = [];

  @override
  void initState() {
    super.initState();

    loadStock();
  }

  Future<void> loadStock() async {
    if (widget.favoriteStocks.isEmpty) {
      setState(() {
        stocks = [];
      });

      return;
    }
    try {
      // 1. 실시간 시세 API
      final symbols = widget.favoriteStocks.toList();
      final List<Stock> newStocks = [];
      for (final symbol in symbols) {
        final data = await api.getRealtimeStock(symbol);
        final areas = data['result']['areas'] as List;
        if (areas.isEmpty) {
          continue;
        }
        final datas = areas[0]['datas'] as List;
        if (datas.isEmpty) {
          continue;
        }
        final stockData = RealtimeStockDto.fromJson(datas[0]);
        // 2. 종목명 + 거래소 정보 API
        final metadata = await api.getStockMetadata(stockData.symbol);
        final stockName = metadata['stockName'];
        final market = metadata['stockExchangeNameKor'];
        // 3. DTO → Stock 변환
        final newStock = convertToStock(
          stockData,
          stockName: stockName,
          market: market,
        );
        newStocks.add(newStock);
      }
      // 4. 화면에 사용할 Stock 저장
      if (!mounted) return;
      setState(() {
        stocks = newStocks;
      });
    } catch (e) {
      print('API 요청 실패: $e');
    }
  }

  @override
  void didUpdateWidget(covariant WatchlistScreen previousWidget) {
    super.didUpdateWidget(previousWidget);

    if (previousWidget.favoriteStocks.length != widget.favoriteStocks.length ||
        !previousWidget.favoriteStocks.containsAll(widget.favoriteStocks)) {
      loadStock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('관심', style: TextStyle(color: colors.textPrimary)),
            const Spacer(),
            TextButton(
              onPressed: () {
                // 정렬
              },
              child: Row(
                children: [
                  Text('가나다순', style: TextStyle(color: colors.textSecondary)),
                  // const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/icons/ico_align.svg',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // 새로고침
              },
              icon: SvgPicture.asset(
                'assets/icons/ico_refresh.svg',
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
      ),

      //관심
      body: widget.favoriteStocks.isEmpty
          ? EmptyState(
              icon: SvgPicture.asset(
                'assets/icons/ico_star.svg',
                width: 40,
                height: 40,
              ),
              title: '관심 종목이 없습니다',
              description: '검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.',
            )
          : ListView(
              children: [
                for (final stock in stocks.where(
                  (stock) => widget.favoriteStocks.contains(stock.stockCode),
                ))
                  StockItem(
                    stockName: stock.stockName,
                    currentPrice: stock.currentPrice,
                    stockCode: stock.stockCode,
                    market: stock.market,
                    changeAmount: stock.changeAmount,
                    changeRate: stock.changeRate,
                  ),
              ],
            ),
    );
  }
}
