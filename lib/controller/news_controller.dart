import 'package:get/get.dart';
import 'package:newsapp/services/news_service.dart';

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  var newsList = <dynamic>[].obs;
  var isLoading = false.obs;
  var selectedCategory = "general".obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  void fetchNews() async {
    isLoading.value = true;
    try {
      var news = await _newsService.fetchNews(
        category: searchQuery.value.isNotEmpty ? "" : selectedCategory.value,
        query: searchQuery.value,
      );
      newsList.assignAll(news);
      update();
    } catch (e) {
      // print("Error fetching news: $e");
    }
    isLoading.value = false;
  }

  void updateCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      searchQuery.value = "";
      fetchNews();
    }
  }

  void searchNews(String query) {
    if (query.isEmpty) {
      fetchNews();
    } else {
      searchQuery.value = query;
      fetchNews();
    }
  }
}
