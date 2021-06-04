import 'package:flutter/material.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/page/article_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text("Welcome to \n WanAndoird",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 36,
                    fontWeight: FontWeight.bold))));
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    Iterable<Future> futures = [
      AppManager.initApp(),
      Future.delayed(Duration(seconds: 3))
    ];
    await Future.wait(futures);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ArticlePage()));
  }
}
