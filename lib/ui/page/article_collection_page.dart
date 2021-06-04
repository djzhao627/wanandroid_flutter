import 'package:flutter/material.dart';
import 'package:flutter_app/http/api.dart';
import 'package:flutter_app/widget/article_item.dart';

class ArticleCollectionPage extends StatefulWidget {
  const ArticleCollectionPage({Key key}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<ArticleCollectionPage> {
  bool _isHideLoading = false;
  List _collections = [];
  ScrollController _scrollController = ScrollController();

  /// 当前页
  int _pageIndex = 0;

  /// 总页数
  int _totalPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // 可以滚动的最大距离
      var maxScroll = _scrollController.position.maxScrollExtent;
      // 当前位置的像素值
      var pixels = _scrollController.position.pixels;
      if (pixels + 30 <= maxScroll && _pageIndex <= _totalPage) {
        _getCollection();
      }
    });
    _getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Offstage(
          offstage: _isHideLoading,
          child: Center(child: CircularProgressIndicator())),
      Offstage(
          offstage: _collections.isNotEmpty || !_isHideLoading,
          child: Center(child: Text("(＞﹏＜) 您还没有任何收藏任何内容..."))),
      Offstage(
          offstage: _collections.isEmpty,
          child: RefreshIndicator(
              onRefresh: () => _getCollection(true),
              child: ListView.builder(
                  itemBuilder: (context, index) => _buildItem(index),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _collections.length,
                  controller: _scrollController)))
    ]);
  }

  _getCollection([bool isRefresh = false]) async {
    if (isRefresh) {
      _pageIndex = 0;
    }
    var result = await Api.getArticleCollections(_pageIndex);
    if (result != null) {
      if (_pageIndex++ == 0) {
        _collections.clear();
      }
      var data = result["data"];
      _collections.addAll(data["datas"]);
      _totalPage = data["pageCount"];
    }
    setState(() {
      _isHideLoading = true;
    });
  }

  _buildItem(int index) {
    _collections[index]["collect"] = true;
    _collections[index]["id"] = _collections[index]["originId"];
    return ArticleItem(_collections[index]);
  }
}
