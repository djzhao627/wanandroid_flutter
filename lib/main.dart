import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/page/article_page.dart';
import 'package:flutter_app/widget/main_drawer.dart';

void main() {
  runApp(ArticleApp());
}

class ArticleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppManager.initApp();
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "文章",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        drawer: Drawer(
          child: MainDrawer(),
        ),
        body: ArticlePage(),
      ),
    );
  }
}
