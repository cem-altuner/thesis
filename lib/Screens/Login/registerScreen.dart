import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:thesis/keys/myKeys.dart';
import 'package:thesis/services/dio.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:http/http.dart' as http;
import 'package:thesis/SharedComponents/alertDialog.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyNameSurname = GlobalKey<FormState>();
  final _formKeyAge = GlobalKey<FormState>();
  final _formKeyCity = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isMale = false;
  bool isFemale = false;
  String error = "";
  String email = "";
  String password = "";
  String nameSurname = "";
  int age = 0;
  String city = "Select a City";

  Future<bool> singInWithUsername(String username, String password) async {
    Map data = {'email': username, 'password': password};
    final response = await dio.post('signup/',
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
        data: json.encode(data));
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  showPickerNumber(BuildContext context) {
    new Picker(
        confirmText: 'Confirm',
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 100),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          this.setState(() {
            this.age = value[0];
          });
        }).showModal(this.context);
  }

  showPickerCities(BuildContext context) {
    new Picker(
        confirmText: 'Confirm',
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(pickerCityData),
            isArray: true),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          this.setState(() {
            this.city = picker.adapter.text
                .substring(1, picker.adapter.text.length - 1);
          });
        }).showModal(this.context);
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email *',
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

  Widget _buildNameSurnameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Name Surname *',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Form(
            key: _formKeyNameSurname,
            child: TextFormField(
              validator: (val) => val.isEmpty ? "Enter Name and Surname" : null,
              onChanged: (val) {
                setState(() {
                  nameSurname = val;
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
                  Icons.person,
                  color: Colors.black87,
                ),
                hintText: 'Enter your name and Surname',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Age *',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: MediaQuery.of(context).size.height * 0.08,
          child: InkWell(
            child: ListTile(
                leading: Icon(Icons.wifi), title: Text(this.age.toString())),
            onTap: () {
              this.showPickerNumber(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCityTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'City *',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: MediaQuery.of(context).size.height * 0.08,
            child: InkWell(
              child: ListTile(
                  leading: Icon(Icons.wifi), title: Text(this.city.toString())),
              onTap: () {
                this.showPickerCities(context);
              },
            )),
      ],
    );
  }

  Widget _buildGenderF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Gender *',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Row(children: <Widget>[
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Male'),
                    Checkbox(
                      value: isMale,
                      onChanged: (bool val) {
                        if (!isFemale) {
                          setState(() {
                            this.isMale = val;
                          });
                        }
                      },
                    )
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Female'),
                    Checkbox(
                      value: isFemale,
                      onChanged: (bool val) {
                        if (!isMale) {
                          setState(() {
                            this.isFemale = val;
                          });
                        }
                      },
                    )
                  ],
                )),
          ]),
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
            'Password *',
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

  Widget _buildRegisterBtn() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: double.infinity,
      child: GFButton(
        elevation: 8.0,
        type: GFButtonType.solid,
        size: GFSize.LARGE,
        onPressed: () async {
          final result =
              await this.singInWithUsername(this.email, this.password);
          if (result == true) {
            Alert.showRegister();
          } else {
            print("There is a problem in Register Screen 363");
          }
        },
        shape: GFButtonShape.pills,
        color: Colors.white,
        child: Text(
          'Register',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildCancelBtn() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: double.infinity,
      child: GFButton(
        elevation: 8.0,
        type: GFButtonType.solid,
        size: GFSize.LARGE,
        onPressed: () async {
          final result =
              await this.singInWithUsername(this.email, this.password);

          NoomiKeys.navKey.currentState.pop();
        },
        shape: GFButtonShape.pills,
        color: Colors.white,
        child: Text(
          'Cancel',
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
          child: _buildCancelBtn(),
        ),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          flex: 1,
          child: _buildRegisterBtn(),
        ),
      ],
    );
  }

  Widget screen() {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
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
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05,
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'REGISTER',
                    textAlign: TextAlign.center,
                    style: kTextTextStyle,
                  ),
                  SizedBox(height: 15.0),
                  _buildNameSurnameTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildEmailTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildPasswordTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildGenderF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildCityTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildAgeTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildButtons()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return screen();
  }
}
