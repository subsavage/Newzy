import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/widgets/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailPage extends StatefulWidget {
  final String title;
  final String url;
  final String source;
  final String imageUrl;
  final String publishedAt;

  const NewsDetailPage({
    super.key,
    required this.title,
    required this.url,
    required this.source,
    required this.imageUrl,
    required this.publishedAt,
  });

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late WebViewController controller;
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => isLoading.value = true,
          onPageFinished: (url) => isLoading.value = false,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: WebViewWidget(controller: controller),
          ),
          Obx(() => isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
