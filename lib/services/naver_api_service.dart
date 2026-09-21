import 'dart:convert';
import 'package:http/http.dart' as http;

class NaverApiService {
  //검색어 종목 후보 조회 api
  Future<dynamic> getQueryTargetStockData(String symbol) async {
    final uri = Uri.parse(
      'https://ac.stock.naver.com/ac',
    ).replace(queryParameters: {'query': 'SERVICE_ITEM:$symbol'});
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('검색어 종목 후보 조회 실패: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  //실시간 시세 api
  Future<dynamic> getRealtimeStock(String symbol) async {
    final uri = Uri.parse(
      'https://polling.finance.naver.com/api/realtime',
    ).replace(queryParameters: {'query': 'SERVICE_ITEM:$symbol'});
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('실시간 시세 조회 실패: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  //종목,거래소명 api
  Future<dynamic> getStockMetadata(String symbol) async {
    final uri = Uri.parse(
      'https://stock.naver.com/api/securityFe/api/fchart/domestic/stock/$symbol',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('종목 정보 조회 실패: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  //일별시세 api
  Future<dynamic> getTimeData(String symbol) async {
    final uri = Uri.parse(
      'https://api.stock.naver.com/chart/domestic/item/$symbol/day',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('일별시세 조회 실패: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }
}
