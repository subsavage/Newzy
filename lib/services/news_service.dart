import 'dart:convert';
import 'package:http/http.dart' as http;

// const String baseUrl = "http://localhost:5000";
const String baseUrl = "http://172.16.123.122:5000";

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

  // Fetch Favorite Articles
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
