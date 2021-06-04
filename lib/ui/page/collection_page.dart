import 'package:flutter/material.dart';
import 'package:flutter_app/res/icons.dart';
import 'package:flutter_app/ui/page/article_collection_page.dart';
import 'package:flutter_app/ui/page/custom_collection_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key key}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final tabs = ["文章", "其他"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
              title: Text("我的收藏"),
              bottom: TabBar(tabs: [
                Tab(
                    icon: Icon(
                  articleIcon,
                  size: 32,
                )),
                Tab(
                    icon: Icon(
                  favorIcon,
                  size: 32,
                ))
              ])),
          body: TabBarView(
              children: [ArticleCollectionPage(), CustomCollectionPage()]),
        ));
  }
}
