import 'package:get/get.dart';
import 'package:newsapp/services/news_service.dart';

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  var newsList = [].obs;
  var isLoading = false.obs;
  var selectedCategory = "general".obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    fetchNews();
    super.onInit();
  }

  void fetchNews() async {
    isLoading.value = true;
    try {
      var news = await _newsService.fetchNews(
        category: selectedCategory.value,
        query: searchQuery.value,
      );
      newsList.assignAll(news);
    } catch (e) {
      print("Error fetching news: $e");
    }
    isLoading.value = false;
  }

  // Update category and fetch news
  void updateCategory(String category) {
    selectedCategory.value = category;
    fetchNews();
  }

  // Search for news articles
  void searchNews(String query) {
    searchQuery.value = query;
    fetchNews();
  }
}
