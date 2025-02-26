import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/controller/news_controller.dart';
import 'package:newsapp/widgets/colors.dart';
import 'package:newsapp/widgets/newscard.dart';

class HomePage extends StatelessWidget {
  final NewsController newsController = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title: const Text(
            "Newzy",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.titleTextColor,
            ),
          )),
      body: Obx(() {
        if (newsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
}
