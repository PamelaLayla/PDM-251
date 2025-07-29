import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String url = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        return jsonData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao carregar produtos');
      }
    } catch (e) {
      throw Exception('Falha de rede: $e');
    }
  }
}
