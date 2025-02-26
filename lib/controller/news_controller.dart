import 'package:get/get.dart';
import 'package:newsapp/services/news_service.dart';

class NewsController extends GetxController {
  var newsList = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchNews();
    super.onInit();
  }

  void fetchNews({String category = "general"}) async {
    isLoading.value = true;
    try {
      var news = await NewsService().fetchNews(category: category);
      newsList.assignAll(news);
    } finally {
      isLoading.value = false;
    }
  }
}
