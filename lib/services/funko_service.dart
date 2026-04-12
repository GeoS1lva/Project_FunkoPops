import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/funko_model.dart';

class FunkoService {
  static const String _apiUrl =
      'https://69d00468a4647a9fc676433e.mockapi.io/api/v1/funkopops';

  Future<List<FunkoModel>> fetchLatestFunkos() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> decodedData = json.decode(response.body);
        List<FunkoModel> funkos = decodedData
            .map((json) => FunkoModel.fromJson(json))
            .toList();

        funkos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return funkos.take(4).toList();
      } else {
        throw Exception('Erro ao buscar dados');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
