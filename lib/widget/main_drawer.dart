import 'package:flutter/material.dart';
import 'package:flutter_app/event/login_event.dart';
import 'package:flutter_app/http/api.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/page/collection_page.dart';
import 'package:flutter_app/ui/page/login_page.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _username;

  @override
  void initState() {
    super.initState();
    AppManager.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        _username = event.username;
        AppManager.sharedPreferences.setString(AppManager.ACCOUNT, _username);
      });
    });
    _username = AppManager.sharedPreferences.getString(AppManager.ACCOUNT);
  }

  @override
  Widget build(BuildContext context) {
    DrawerHeader drawerHeader = DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: InkWell(
            onTap: () {
              if (_username == null) {
                _drawerClick(null);
              }
            },
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage("assets/images/logo.png"))),
                Text(_username ?? "请登录",
                    style: TextStyle(color: Colors.white, fontSize: 18))
              ],
            )));

    InkWell myFavor = InkWell(
        child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text("我的收藏", style: const TextStyle(fontSize: 16))),
        onTap: () {
          _drawerClick(CollectionPage());
        });

    Offstage doLogout = Offstage(
        offstage: _username == null,
        child: InkWell(
            child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("退出登录", style: const TextStyle(fontSize: 16))),
            onTap: () {
              setState(() {
                AppManager.sharedPreferences.remove(AppManager.ACCOUNT);
                _username = null;
                Api.clearUserCookie();
              });
            }));

    Offstage divider = Offstage(
        offstage: _username == null,
        child: Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Divider(color: Colors.grey)));

    return ListView(
        children: [drawerHeader, myFavor, divider, doLogout],
        padding: EdgeInsets.zero);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _drawerClick(Widget page) {
    var targetPage = _username == null ? LoginPage() : page;
    if (targetPage != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => targetPage));
    }
  }
}
