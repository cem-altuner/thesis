import 'dart:io';

import 'package:getwidget/size/gf_size.dart';
import 'package:thesis/Classes/authHandler.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/keys/myKeys.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/services/dio.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:thesis/SharedComponents/alertDialog.dart';

class LoginScreen2 extends StatefulWidget {
  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final AuthHandler handler = AuthHandler();

  bool isLoading = false;
  bool _rememberMe = false;
  String error = "";
  String email = "";
  String password = "";

  Future<bool> singInWithUsername(String username, String password) async {
    try {
      Map data = {'username': username, 'password': password};
      final response = await dio.post('auth/token/',
          options: Options(
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          ),
          data: data);
      if (response.statusCode == 200) {
        String token = response.data['token'];
        this._rememberMe
            ? await this.handler.setAuthToken(token)
            : print('Not Remember me');
        StoreProvider.of<AppState>(context).dispatch(authTokenAction(token));
        return true;
      } else {
        this.setState(() {
          this.isLoading = false;
        });
        return false;
      }
    } on DioError catch (e) {
      this.setState(() {
        this.isLoading = false;
      });
      Alert.showLogin('Sorry');
    }
  }

  Widget appLogo() {
    return Icon(
      Icons.shopping_basket,
      size: MediaQuery.of(context).size.height * 0.12,
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Form(
            key: _formKeyEmail,
            child: TextFormField(
              validator: (val) => val.isEmpty ? "Enter a mail" : null,
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
              keyboardType: TextInputType.emailAddress,
              style: kFormTextStyle,
              decoration: InputDecoration(
                errorStyle: kErrorTextStyle,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                hintText: 'Enter your Email',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Password',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Form(
            key: _formKeyPassword,
            child: TextFormField(
              validator: (val) => val.isEmpty ? "Enter an password" : null,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
              obscureText: false,
              style: kFormTextStyle,
              decoration: InputDecoration(
                errorStyle: kErrorTextStyle,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black87,
                ),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                  print(_rememberMe);
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: double.infinity,
      child: GFButton(
        elevation: 8.0,
        type: GFButtonType.solid,
        size: GFSize.LARGE,
        onPressed: () async {
          this.setState(() {
            this.isLoading = true;
          });
          final result =
              await this.singInWithUsername(this.email, this.password);
          if (result == true) {
            NoomiKeys.navKey.currentState.popAndPushNamed('/splash');
          } else {
            print("There is a problem with login");
          }
        },
        shape: GFButtonShape.pills,
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: kButtonTextStyle,
        ),
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: double.infinity,
      child: GFButton(
        elevation: 8.0,
        type: GFButtonType.solid,
        size: GFSize.SMALL,
        onPressed: () async {
          Navigator.of(context).pushNamed('/register');
        },
        shape: GFButtonShape.pills,
        color: Colors.white,
        child: Text(
          'REGISTER',
          style: kButtonTextStyle,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _buildRegisterBtn(),
        ),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          flex: 1,
          child: _buildLoginBtn(),
        ),
      ],
    );
  }

  Widget loginItems() {
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.15,
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'KOAL APP',
              textAlign: TextAlign.center,
              style: kTextTextStyle,
            ),
            appLogo(),
            Text(
              'Shopping lists with all discounts!',
              textAlign: TextAlign.center,
              style: kTextTextStyle,
            ),
            Text(
              'Kullanıcı Adı : beingbraved@gmail.com\nşifre : elijah60',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0,color: Colors.white),
            ),
            SizedBox(height: 30.0),
            _buildEmailTF(),
            SizedBox(
              height: 20.0,
            ),
            _buildPasswordTF(),
            _buildForgotPasswordBtn(),
            _buildRememberMeCheckbox(),
            SizedBox(
              height: 20.0,
            ),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget screen() {
    Widget widget;
    if (this.isLoading == true) {
      widget = GFLoader(
        type: GFLoaderType.android,
      );
    } else {
      widget = loginItems();
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFff4040),
                    Color(0xFFff5353),
                    Color(0xFFff6666),
                    Color(0xFFff7979),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
              ),
            ),
            widget,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return screen();
  }
}
