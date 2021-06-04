import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api.dart';
import 'package:flutter_app/ui/page/add_custom_collection_page.dart';
import 'package:flutter_app/ui/page/web_view_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomCollectionPage extends StatefulWidget {
  const CustomCollectionPage({Key key}) : super(key: key);

  @override
  _CustomCollectionPageState createState() => _CustomCollectionPageState();
}

class _CustomCollectionPageState extends State<CustomCollectionPage> {
  bool _isHideLoading = false;
  List _collections = [];

  @override
  void initState() {
    super.initState();
    _getCollections();
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
              onRefresh: () => _getCollections(),
              child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  itemCount: _collections.length,
                  itemBuilder: (context, index) => _buildItem(index),
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.grey);
                  }))),
      Positioned(
          bottom: 18,
          right: 18,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _addCollection,
          ))
    ]);
  }

  _getCollections() async {
    var result = await Api.getCustomCollections();
    _isHideLoading = true;
    if (result != null) {
      _collections.clear();
      _collections.addAll(result["data"]);
    }
    setState(() {});
  }

  _buildItem(int index) {
    var item = _collections[index];
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: InkWell(
          onTap: () {
            if (item["link"].toString().startsWith("http")) {
              item["title"] = item["name"];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => WebViewPage(viewData: item)));
            }
          },
          child: Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["name"], style: TextStyle(fontSize: 20)),
                Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(item["link"],
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)))
              ],
            ),
          ),
        ),
        secondaryActions: [
          IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _deleteCollection(item),
          )
        ]);
  }

  _addCollection() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => AddCustomCollectionPage()));
    if (result != null) {
      setState(() {
        _collections.add(result);
      });
    }
  }

  _deleteCollection(item) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()));
    var result = await Api.unCollectCustom(item["id"]);
    Navigator.pop(context);
    if (result["errorCode"] != 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result["errorMsg"])));
    } else {
      setState(() {
        _collections.remove(item);
      });
    }
  }
}
