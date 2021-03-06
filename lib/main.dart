import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/page/splash_page.dart';

void main() {
  runApp(ArticleApp());
}

class ArticleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      routes: {"/": (_) => SplashPage()},
    );
  }
}
