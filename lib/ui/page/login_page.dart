import 'package:flutter/material.dart';
import 'package:flutter_app/event/login_event.dart';
import 'package:flutter_app/http/api.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/page/register_page.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _username, _password;

  FocusNode _passwordNode = FocusNode();

  var _isHidePassword = true;
  Color _passwordIconColor;

  @override
  void dispose() {
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("登录")),
        body: Form(
            key: _formKey,
            child: ListView(
                padding: EdgeInsets.only(left: 18, right: 18),
                children: [
                  _buildUsernameInput(),
                  _buildPasswordInput(),
                  _buildLoginBtn(),
                  _buildRegisterBtn()
                ])));
  }

  _buildUsernameInput() {
    return TextFormField(
        autofocus: true,
        decoration: InputDecoration(labelText: "用户名"),
        initialValue: _username,
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(_passwordNode);
        },
        validator: (value) {
          if (value.trim().isEmpty) {
            return "请输入用户名";
          }
          _username = value;
          return null;
        });
  }

  _buildPasswordInput() {
    return TextFormField(
        focusNode: _passwordNode,
        obscureText: _isHidePassword,
        decoration: InputDecoration(
            labelText: "密码",
            suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye, color: _passwordIconColor),
                onPressed: () {
                  setState(() {
                    _isHidePassword = !_isHidePassword;
                    _passwordIconColor = _isHidePassword
                        ? Colors.grey
                        : Theme.of(context).iconTheme.color;
                  });
                })),
        initialValue: _password,
        textInputAction: TextInputAction.go,
        onEditingComplete: _doLogin,
        validator: (value) {
          if (value.trim().isEmpty) {
            return "请输入密码";
          }

          _password = value;
          return null;
        });
  }

  _buildLoginBtn() {
    return Container(
        height: 45,
        margin: EdgeInsets.only(top: 18, left: 10, right: 10),
        child: ElevatedButton(
            child: Text(
              "登录",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            onPressed: _doLogin));
  }

  _buildRegisterBtn() {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("没有账号？"),
          GestureDetector(
            child: Text(" 点击注册", style: TextStyle(color: Colors.green)),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RegisterPage();
              }));
            },
          )
        ]));
  }

  void _doLogin() async {
    _passwordNode.unfocus();
    if (_formKey.currentState.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Center(child: CircularProgressIndicator()));
      var result = await Api.login(_username, _password);
      Navigator.pop(context);
      if (result["errorCode"] == -1) {
        Toast.show(result["errorMsg"], context);
      } else {
        AppManager.eventBus.fire(LoginEvent(_username));
        Navigator.pop(context);
      }
    }
  }
}
