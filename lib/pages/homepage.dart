import 'package:flutter/material.dart';
import 'package:newsapp/services/news_service.dart';
import 'package:newsapp/widgets/newscard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsService _newsService = NewsService();
  List<dynamic> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      List<dynamic> articles = await _newsService.fetchNews();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error loading news: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("News App")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return NewsCard(
                  title: article["title"] ?? "No Title",
                  description: article["description"] ?? "No Description",
                  imageUrl: article["urlToImage"] ?? "",
                  source: article["source"]["name"] ?? "Unknown",
                  publishedAt: article["publishedAt"] ?? "",
                  url: article["url"] ?? "",
                );
              },
            ),
    );
  }
}
