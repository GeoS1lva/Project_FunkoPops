import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart'; // Ajuste o caminho se necessário

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
}
