import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  static const String _apiUrl =
      'https://69d00468a4647a9fc676433e.mockapi.io/api/v1/categorias';

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> decodedData = json.decode(response.body);
        return decodedData.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Falha ao carregar categorias. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<bool> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(categoryData),
      );

      if (response.statusCode == 201) {
        return true; // Sucesso
      } else {
        print('Erro ao cadastrar categoria: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }
}
