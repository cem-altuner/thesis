import 'dart:async';

import 'package:thesis/SharedComponents/waitScreen.dart';
import 'package:thesis/model/appState.dart';

import 'package:thesis/Screens/Home/homeScreen.dart';
import 'package:thesis/Screens/Offline/offlineScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:connectivity/connectivity.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> _checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Store store = StoreProvider.of<AppState>(context);
    return FutureBuilder(
      future: this._checkInternetConnection(),
      builder: (
        context,
        AsyncSnapshot<bool> snapshot,
      ) {
        if (!snapshot.hasData) {
          return WaitScreen(
            title: 'KOAL',
          );
        }

        if (snapshot.data) {
          return HomeScreen3();
        } else {
          return HomeScreen3();
        }
      },
    );
  }
}
