import 'package:flutter/material.dart';
import 'package:flutter_app/event/collection_change_event.dart';
import 'package:flutter_app/http/api.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/page/login_page.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final viewData;

  bool canCollect = false;

  WebViewPage({Key key, this.viewData, this.canCollect = false})
      : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = true;
  FlutterWebviewPlugin webviewPlugin;

  @override
  void initState() {
    super.initState();
    webviewPlugin = FlutterWebviewPlugin();
    webviewPlugin.onStateChanged.listen((event) {
      if (event.type == WebViewState.finishLoad) {
        setState(() {
          isLoading = false;
        });
      } else if (event.type == WebViewState.startLoad) {
        setState(() {
          isLoading = true;
        });
      }
    });
    webviewPlugin.onUrlChanged.listen((url) {
      debugPrint("new url: $url");
      if (!url.startsWith("http")) {
        /*webviewPlugin.reloadUrl(url);*/
        webviewPlugin.stopLoading();
        _launchURL(url);
      }
    });
  }

  @override
  void dispose() {
    webviewPlugin.dispose();
    super.dispose();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      var re = await launch(url);
      debugPrint("re：$re");
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("webViewData:${widget.viewData}");
    String url = widget.viewData["link"] ?? widget.viewData["url"];
    bool hasCollect = widget.viewData["collect"] ?? false;
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        title: Text(widget.viewData["title"]),
        actions: [
          Offstage(
              offstage: !widget.canCollect,
              child: IconButton(
                  icon: Icon(Icons.favorite,
                      color: hasCollect ? Colors.red : Colors.grey),
                  onPressed: _collect))
        ],
        bottom: PreferredSize(
          preferredSize: !isLoading
              ? const Size.fromHeight(0.0)
              : const Size.fromHeight(1.0),
          child: const LinearProgressIndicator(),
        ),
        bottomOpacity: isLoading ? 1.0 : 0.0,
      ),
      withLocalStorage: true,
      clearCache: true,
      withJavascript: true,
      withZoom: true,
      debuggingEnabled: true,
    );
  }

  _collect() async {
    if (!AppManager.isLogin()) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
      return;
    }
    var result;
    bool hasCollect = widget.viewData["collect"] ?? false;
    if (hasCollect) {
      result = await Api.unCollectArticle(widget.viewData["id"]);
    } else {
      result = await Api.collectArticle(widget.viewData["id"]);
    }
    if (result["errorCode"] == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(hasCollect ? "已取消收藏" : "收藏成功")));
      AppManager.eventBus
          .fire(CollectionChangeEvent(widget.viewData["id"], !hasCollect));
      setState(() {
        widget.viewData["collect"] = !hasCollect;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result["errorMsg"])));
    }
  }
}
