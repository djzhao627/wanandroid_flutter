import 'package:flutter/material.dart';
import 'package:flutter_app/http/api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  FocusNode _userNameNode = new FocusNode();
  FocusNode _pwdNode = new FocusNode();
  FocusNode _pwd2Node = new FocusNode();

  String _username, _password;


  @override
  void dispose() {
    _userNameNode.dispose();
    _pwdNode.dispose();
    _pwd2Node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("注册")),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0.0),
            children: [
              _buildUsernameInput(),
              _buildPasswordInput(),
              _buildPasswordReInput(),
              _buildRegisterBtn(),
            ],
          ),
        ));
  }

  _buildUsernameInput() {
    return TextFormField(
        autofocus: true,
        focusNode: _userNameNode,
        decoration: InputDecoration(labelText: "用户名"),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_pwdNode),
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
        focusNode: _pwdNode,
        obscureText: true,
        decoration: InputDecoration(labelText: "密码"),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_pwd2Node),
        validator: (value) {
          if (value.trim().isEmpty) {
            return "请输入密码";
          }
          _password = value;
          return null;
        });
  }

  _buildPasswordReInput() {
    return TextFormField(
        focusNode: _pwd2Node,
        obscureText: true,
        decoration: InputDecoration(labelText: "确认密码"),
        textInputAction: TextInputAction.go,
        onEditingComplete: _doRegister,
        validator: (value) {
          if (value.trim().isEmpty) {
            return "请再次输入密码";
          }
          if (_password != value) {
            return "两次输入的密码不一致";
          }
          return null;
        });
  }

  _buildRegisterBtn() {
    return Container(
        height: 45,
        margin: EdgeInsets.only(top: 18, left: 10, right: 10),
        child: ElevatedButton(
            child: Text(
              "注册",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            onPressed: _doRegister));
  }

  _doRegister() async {
    _userNameNode.unfocus();
    _pwdNode.unfocus();
    _pwd2Node.unfocus();

    if (_formKey.currentState.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Center(child: CircularProgressIndicator()));
      var result = await Api.register(_username, _password);
      Navigator.pop(context);
      if (result["errorCode"] == -1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result["errorMsg"])));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("注册成功")));
        Navigator.pop(context);
      }
    }
  }
}
