import 'package:edencrew_assignment_starter/screens/search_screen.dart';
import 'package:edencrew_assignment_starter/screens/watchlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  Set<String> favoriteStocks = {};

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: [
          WatchlistScreen(favoriteStocks: favoriteStocks),
          SearchScreen(
            favoriteStocks: favoriteStocks,
            onFavoriteChanged: (stockCode) {
              setState(() {
                if (favoriteStocks.contains(stockCode)) {
                  favoriteStocks.remove(stockCode);
                } else {
                  favoriteStocks = {...favoriteStocks, stockCode};
                }
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedTab = 0;
                });
                //관심
              },
              child: Column(
                children: [
                  selectedTab == 0
                      ? SvgPicture.asset(
                          'assets/icons/ico_starFill.svg',
                          width: 22,
                          height: 22,
                        )
                      : SvgPicture.asset(
                          'assets/icons/ico_star.svg',
                          width: 22,
                          height: 22,
                        ),
                  Text(
                    '관심',
                    style: TextStyle(
                      color: selectedTab == 0
                          ? colors.textPrimary
                          : colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                //검색
                setState(() {
                  selectedTab = 1;
                });
              },
              child: Column(
                children: [
                  selectedTab == 1
                      ? SvgPicture.asset(
                          'assets/icons/ico_search_active.svg',
                          width: 22,
                          height: 22,
                        )
                      : SvgPicture.asset(
                          'assets/icons/ico_search.svg',
                          width: 22,
                          height: 22,
                        ),
                  Text(
                    '검색',
                    style: TextStyle(
                      color: selectedTab == 1
                          ? colors.navActive
                          : colors.navInactive,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
