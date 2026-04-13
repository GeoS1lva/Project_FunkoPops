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

  Future<List<FunkoModel>> fetchAllFunkos() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> decodedData = json.decode(response.body);
        return decodedData.map((json) => FunkoModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Falha ao carregar a listagem. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro de conexão na listagem: $e');
    }
  }

  Future<bool> createFunko(Map<String, dynamic> funkoData) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(funkoData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Erro ao cadastrar: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }

  Future<bool> updateFunko(FunkoModel funko) async {
    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/${funko.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": funko.name,
          "categoryName": funko.categoryName,
          "number": funko.number,
          "rarity": funko.rarity,
          "isGlowInTheDark": funko.isGlowInTheDark,
          "image": funko.image,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao atualizar: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão no update: $e');
      return false;
    }
  }

  Future<bool> deleteFunko(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_apiUrl/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao deletar: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão no delete: $e');
      return false;
    }
  }
}
