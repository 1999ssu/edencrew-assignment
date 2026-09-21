import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../theme/theme.dart';

class StockItem extends StatelessWidget {
  final String stockName;
  final int currentPrice;
  final String stockCode;
  final String market;
  final int changeAmount;
  final double changeRate;

  // 검색
  final bool isFavorite;
  final String searchKeyword;

  // 가격 표시 여부
  final bool showPrice;

  // 즐겨찾기 클릭
  final VoidCallback? onFavoritePressed;

  const StockItem({
    super.key,
    required this.stockName,
    required this.stockCode,
    required this.market,
    this.currentPrice = 0,
    this.changeAmount = 0,
    this.changeRate = 0,
    this.isFavorite = false,
    this.searchKeyword = '',
    this.showPrice = true,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color changeColor;
    final AppColors colors = context.colors;

    if (changeAmount > 0) {
      changeColor = context.colors.priceUpText;
    } else if (changeAmount < 0) {
      changeColor = context.colors.priceDownText;
    } else {
      changeColor = context.colors.priceFlatText;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //종목명
                  _buildStockName(context),
                  DefaultTextStyle(
                    style: TextStyle(fontSize: 15, color: colors.textSecondary),
                    child: Row(
                      children: [
                        Text(stockCode),
                        const Text(' · '),
                        Text(market),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 관심 화면
            if (showPrice)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormat('#,###').format(currentPrice),
                      style: TextStyle(fontSize: 15, color: colors.textPrimary),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(changeAmount)} '
                      '(${changeRate.toStringAsFixed(2)}%)',
                      style: TextStyle(fontSize: 11, color: changeColor),
                    ),
                  ],
                ),
              ),

            // 검색 화면
            if (!showPrice)
              IconButton(
                onPressed: onFavoritePressed,
                icon: SvgPicture.asset(
                  isFavorite
                      ? 'assets/icons/ico_starFill_point.svg'
                      : 'assets/icons/ico_star.svg',
                  width: 20,
                  height: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockName(BuildContext context) {
    final AppColors colors = context.colors;
    final textStyle = TextStyle(fontSize: 15, color: colors.textPrimary);
    if (searchKeyword.trim().isEmpty) {
      return Text(stockName, style: textStyle);
    }
    final keyword = searchKeyword.trim();
    final lowerName = stockName.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();
    final startIndex = lowerName.indexOf(lowerKeyword);
    if (startIndex == -1) {
      return Text(stockName, style: textStyle);
    }
    final endIndex = startIndex + keyword.length;
    return Text.rich(
      TextSpan(
        style: textStyle,
        children: [
          TextSpan(text: stockName.substring(0, startIndex)),
          TextSpan(
            text: stockName.substring(startIndex, endIndex),
            style: TextStyle(color: context.colors.searchHighlight),
          ),

          TextSpan(text: stockName.substring(endIndex)),
        ],
      ),
    );
  }
}
