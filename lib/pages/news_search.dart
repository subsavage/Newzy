import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/controller/news_controller.dart';
import 'package:newsapp/widgets/colors.dart';
import 'package:newsapp/widgets/newscard.dart';

class NewsSearchDelegate extends SearchDelegate {
  final NewsController newsController;

  NewsSearchDelegate(this.newsController);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: AppColors.contentTextColor,
        ),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.contentTextColor),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        color: AppColors.backgroundColor,
        child: const Center(
          child: Text(
            "Type something to search...",
            style: TextStyle(color: AppColors.contentTextColor),
          ),
        ),
      );
    }

    newsController.searchNews(query);

    return Container(
      color: AppColors.backgroundColor,
      child: Obx(() {
        if (newsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (newsController.newsList.isEmpty) {
          return const Center(
            child: Text(
              "No results found",
              style: TextStyle(color: AppColors.contentTextColor),
            ),
          );
        }
        return ListView.builder(
          itemCount: newsController.newsList.length,
          itemBuilder: (context, index) {
            var article = newsController.newsList[index];
            return NewsCard(
              title: article["title"],
              description: article["description"] ?? "No description",
              imageUrl: article["urlToImage"] ?? "",
              source: article["source"]["name"] ?? "Unknown",
              publishedAt: article["publishedAt"],
              url: article["url"],
            );
          },
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: const Center(
        child: Text(
          "Search for news...",
          style: TextStyle(color: AppColors.contentTextColor),
        ),
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        iconTheme: IconThemeData(color: AppColors.contentTextColor),
        titleTextStyle: TextStyle(
          color: AppColors.contentTextColor,
          fontSize: 20,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: AppColors.contentTextColor,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.titleTextColor,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.titleTextColor,
        selectionColor: AppColors.contentTextColor,
        selectionHandleColor: AppColors.titleTextColor,
      ),
    );
  }
}
