import 'package:flutter/material.dart';
import 'package:flutter_app/http/api.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key key}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  bool _isHideLoading = false;
  int _pageIndex = 1;
  List _collections;

  @override
  void initState() {
    super.initState();
    _getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("我的收藏")),
        body: Stack(children: [
          Offstage(
              offstage: _isHideLoading,
              child: Center(child: CircularProgressIndicator())),
          Offstage(
              offstage: _collections?.isEmpty ?? !_isHideLoading,
              child: Center(child: Text("您还没有任何收藏任何内容...")))
        ]));
  }

  void _getCollection() async {
    var result = await Api.getCollection(_pageIndex++);
    setState(() {
      _collections = result["datas"];
      _isHideLoading = true;
    });
  }
}
