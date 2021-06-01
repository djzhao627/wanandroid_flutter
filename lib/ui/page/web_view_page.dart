import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final viewData;

  const WebViewPage({Key key, this.viewData}) : super(key: key);

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
    debugPrint("viewData:${widget.viewData}");
    String url = widget.viewData["link"] ?? widget.viewData["url"];
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        title: Text(widget.viewData["title"]),
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
}
