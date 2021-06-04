import 'package:flutter/material.dart';
import 'package:flutter_app/http/api.dart';

class AddCustomCollectionPage extends StatefulWidget {
  const AddCustomCollectionPage({Key key}) : super(key: key);

  @override
  _AddCustomCollectionPageState createState() =>
      _AddCustomCollectionPageState();
}

class _AddCustomCollectionPageState extends State<AddCustomCollectionPage> {
  String _name;
  String _link;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("新增收藏"),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
                padding: EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0.0),
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: '名称',
                    ),
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return '请输入名称';
                      }
                      _name = value;
                      return null;
                    },
                  ),
                  TextFormField(
                      initialValue: "http://",
                      decoration: InputDecoration(
                        labelText: '网址或者其他',
                      ),
                      keyboardType: TextInputType.url,
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return '请输入要收藏的网站或者其内容';
                        }
                        _link = value;
                        return null;
                      }),
                  Container(
                      height: 45.0,
                      margin: EdgeInsets.only(top: 18.0, left: 8.0, right: 8.0),
                      child: ElevatedButton(
                        child: Text(
                          '收藏',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () => _doAdd(context),
                      ))
                ])));
  }

  _doAdd(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Center(child: CircularProgressIndicator()));
      var result = await Api.collectCustom(_name, _link);
      Navigator.pop(context);
      if (result["errorCode"] != 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result["errorMsg"])));
      } else {
        Navigator.pop(context, result["data"]);
      }
    }
  }
}
