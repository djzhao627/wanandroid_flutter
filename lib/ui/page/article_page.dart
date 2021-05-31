import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api.dart';
import 'package:flutter_app/widget/article_item.dart';
import 'package:flutter_app/widget/banner_item.dart';

class ArticlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArticlePageState();
  }
}

class _ArticlePageState extends State<ArticlePage> {
  /// 滑动控制器
  ScrollController _controller = ScrollController();

  /// 是否隐藏加载动画
  bool _isHideLoading = false;

  /// 当前页码
  int curPage = 1;

  /// 总页数
  int totalPage = 0;

  /// banner列表
  List banners = [];

  /// 文章列表
  List articles = [];

  @override
  void initState() {
    _controller.addListener(() {
      /// 最大可以滚动的范围
      var maxScroll = _controller.position.maxScrollExtent;

      /// 当前滚动位置的像素值
      var curScroll = _controller.position.pixels;

      /// 当前位置即将达到底部，并且还有更多数据时
      if (maxScroll <= curScroll + 30) {
        _getArticleList();
      }
    });

    _initAllData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          offstage: _isHideLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Offstage(
          offstage: !_isHideLoading,
          child: ListView.builder(
            itemBuilder: (context, index) => _buildItem(index),

            /// 多出来的一条记录给Banner使用
            itemCount: articles.length + 1,
            controller: _controller,
          ),
        )
      ],
    );
  }

  _buildItem(int index) {
    if (index == 0) {
      List<Widget> list = banners
          .map((item) => Image.network(
                item["imagePath"],
                fit: BoxFit.cover,
              ))
          .toList();
      return Container(
        /// 设置高度为屏幕高度 * 0.3
        height: MediaQuery.of(context).size.height * 0.3,
        child: BannerItem(list),
      );
    }

    var article = articles[index - 1];
    return ArticleItem(article);
  }

  /// 初始化当前页面的数据，同步方法
  Future<void> _initAllData() async {
    curPage = 1;

    /// 组合两个异步方法，两个都完成后返回一个新的Future
    Iterable<Future> futures = [_getBanner(), _getArticleList()];

    /// Waits for multiple futures to complete and collects their results.
    await Future.wait(futures);

    _isHideLoading = true;

    /// 调用setState即可进行页面刷新
    setState(() {});

    return null;
  }

  /// 获取banner数据
  _getBanner([update = true]) async {
    var data = await Api.getBanner();
    if (data != null) {
      banners.clear();
      banners.addAll(data["data"]);
      if (update == true) {
        setState(() {});
      }
    }
  }

  /// 获取文章列表，分页
  _getArticleList([update = true]) async {
    var data = await Api.getArticleList(curPage);
    if (data != null) {
      var map = data["data"];
      var datas = map["datas"];
      totalPage = map["pageCount"];
      if (curPage++ == 1) {
        articles.clear();
      }
      articles.addAll(datas);
      if (update == true) {
        setState(() {});
      }
    }
  }
}
