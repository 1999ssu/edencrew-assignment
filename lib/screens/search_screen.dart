import 'package:edencrew_assignment_starter/models/realtime_stock_dto.dart';
import 'package:edencrew_assignment_starter/models/stock.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/untils/stock_converter.dart';
import 'package:edencrew_assignment_starter/widgets/empty_state.dart';
import 'package:edencrew_assignment_starter/widgets/stock_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models//search_stock.dart';
import '../services/naver_api_service.dart';

class SearchScreen extends StatefulWidget {
  final Set<String> favoriteStocks;
  final ValueChanged<String> onFavoriteChanged;

  const SearchScreen({
    super.key,
    required this.favoriteStocks,
    required this.onFavoriteChanged,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int selectedTab = 0;
  final NaverApiService api = NaverApiService();
  final TextEditingController searchController = TextEditingController();
  List<Stock> stocks = [];
  List<SearchStock> searchResults = [];

  Future<void> searchStocks(String keyword) async {
    if (keyword.trim().isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    try {
      final data = await api.getSearchStock(keyword);
      final items = data['items'] as List;
      final results = items
          .where((item) {
            final json = item as Map<String, dynamic>;
            final code = json['code'] as String?;
            return code != null && RegExp(r'^\d{6}$').hasMatch(code);
          })
          .map((item) => SearchStock.fromJson(item as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      debugPrint('검색 실패: $e');
    }
  }

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
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: colors.surfaceSunken,
              border: Border.all(color: colors.borderStrong, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8, top: 1),
                  child: SvgPicture.asset(
                    'assets/icons/ico_search.svg',
                    width: 16,
                    height: 16,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: '종목명 또는 종목코드 검색',
                      hintStyle: TextStyle(
                        color: colors.textTertiary,
                        fontSize: 15,
                        height: 20 / 15,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {});
                      searchStocks(value);
                    },
                    style: TextStyle(fontSize: 15, height: 20 / 15),
                  ),
                ),
                if (searchController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        searchController.clear();
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        'assets/icons/ico_x.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: searchController.text.trim().isEmpty
          ? EmptyState(
              icon: SvgPicture.asset(
                'assets/icons/ico_search.svg',
                width: 40,
                height: 40,
              ),
              title: '종목을 검색해 보세요',
              description: '종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.',
            )
          : searchResults.isEmpty
          ? EmptyState(
              icon: SvgPicture.asset(
                'assets/icons/ico_search.svg',
                width: 40,
                height: 40,
              ),
              title: '${searchController.text} 와 일치하는\n 검색 결과를 찾지 못했습니다.',
            )
          : ListView(
              children: [
                for (final stock in searchResults)
                  StockItem(
                    stockName: stock.stockName,
                    stockCode: stock.stockCode,
                    market: stock.market,
                    searchKeyword: searchController.text,
                    showPrice: false,
                    isFavorite: widget.favoriteStocks.contains(stock.stockCode),
                    onFavoritePressed: () {
                      widget.onFavoriteChanged(stock.stockCode);
                    },
                  ),
              ],
            ),
    );
  }
}
