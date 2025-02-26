import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String baseUrl = dotenv.env['BASE_URL'] ?? "Url not found";

class NewsService {
  // Fetch News by Category
  Future<List<dynamic>> fetchNews({String category = "general"}) async {
    final response =
        await http.get(Uri.parse("$baseUrl/news?category=$category"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load news");
    }
  }

  Future<List<dynamic>> fetchFavorites() async {
    final response = await http.get(Uri.parse("$baseUrl/favorites"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load favorites");
    }
  }

  // Add to Favorites
  Future<void> addToFavorites(
      String title, String url, String source, String category) async {
    final response = await http.post(
      Uri.parse("$baseUrl/favorites"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(
          {"title": title, "url": url, "source": source, "category": category}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to save article");
    }
  }

  // Remove from Favorites
  Future<void> removeFromFavorites(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/favorites/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete article");
    }
  }
}
