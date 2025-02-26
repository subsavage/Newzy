import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:newsapp/controller/news_controller.dart';

class NewsSearchDelegate extends SearchDelegate {
  final NewsController newsController;

  NewsSearchDelegate(this.newsController);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    newsController.searchNews(query);

    return Obx(() {
      if (newsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (newsController.newsList.isEmpty) {
        return const Center(child: Text("No results found"));
      }
      return ListView.builder(
        itemCount: newsController.newsList.length,
        itemBuilder: (context, index) {
          var article = newsController.newsList[index];
          return ListTile(
            title: Text(article["title"]),
            subtitle: Text(article["source"]["name"] ?? "Unknown"),
            leading: article["urlToImage"] != null
                ? Image.network(article["urlToImage"],
                    width: 50, height: 50, fit: BoxFit.cover)
                : null,
            onTap: () {
              // Open article
            },
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
