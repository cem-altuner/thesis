import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:thesis/Classes/authHandler.dart';
import 'package:thesis/Classes/ShoppingLists/Offline/offlineShoppingListHandler.dart';
import 'package:thesis/SharedComponents/alertDialog.dart';
import 'package:thesis/SharedComponents/waitScreen.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/Screens/Company/companyGridNavigationService.dart';
import 'package:thesis/Screens/Company/companyTabScreenBuilder.dart';
import 'package:thesis/Screens/ShoppingList/customerShoppingListsScreenBuilder.dart';
import 'package:thesis/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:async/async.dart';
import 'package:thesis/Screens/ShoppingList/shoppingListTabNavigationService.dart';
import 'package:thesis/keys/myKeys.dart';

class HomeScreen3 extends StatefulWidget {
  @override
  _HomeScreenState3 createState() => _HomeScreenState3();
}

class _HomeScreenState3 extends State<HomeScreen3>
    with TickerProviderStateMixin {
  final ShopTabNavigationService service =
      new ShopTabNavigationService(new GlobalKey<NavigatorState>());
  final CompanyTabNavigationService serviceCom =
      new CompanyTabNavigationService(new GlobalKey<NavigatorState>());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthHandler handler = AuthHandler();
  int _currentIndex = 1;
  final List<Widget> _children = [];

  OfflineShoppingListHandler offlineHandler = OfflineShoppingListHandler();
  TabController tabController;
  AsyncMemoizer _memorizer = AsyncMemoizer<List<bool>>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _children.add(CompanyTabScreenBuilder(serviceCom));
    _children.add(CustomerShoppingListsBuilder(service));
    this.offlineHandler.setupOfflineHandler(true);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<bool> _checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  //Fetch data run once
  _fetchData(Store store) {
    return this._memorizer.runOnce(() async {
      try {
        return await Future.wait([
          fCustomer(store),
          fList(store),
        ]).timeout(Duration(seconds: 2), onTimeout: () {
          return [false];
        });
      } on DioError {
        Alert.showConnectionAlert();
        return [false];
      }
      ;
    });
  }

  //Drawer
  Widget drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: DrawerHeader(
              child: Center(
                  child: Icon(
                Icons.print,
                size: 100.0,
              )),
              decoration: BoxDecoration(
                color: Color(0xFF6200EA),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Center(child: Text('User Details')),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Center(child: Text('Settings')),
                    onTap: () {
                      NoomiKeys.navKey.currentState.pop();
                      NoomiKeys.navKey.currentState
                          .pushReplacementNamed('/offline');
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Center(child: Text('Prefences')),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Center(child: Text('SignOut')),
                    onTap: () {
                      this.offlineHandler.deleteOfflineData();
                      this.handler.deleteAuthToken();
                      NoomiKeys.navKey.currentState.pop();
                      NoomiKeys.navKey.currentState.popAndPushNamed('/login');
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //Screen
  Widget screen() {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          endDrawer: Container(
              width: MediaQuery.of(context).size.width * 0.5, child: drawer()),
          key: scaffoldKey,
          body: Stack(
            children: <Widget>[
              _children[_currentIndex],
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.8],
                tileMode: TileMode.mirror,
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _currentIndex,
              onTap: (int index) {
                if (_currentIndex == index) {
                  switch (index) {
                    case 0:
                      this.serviceCom.companyTabPopUntil1();
                      break;
                    case 1:
                      this.service.shoppingTabPopUntil1();
                      break;
                  }
                }
                if (index != 2) {
                  setState(() {
                    this._checkInternetConnection().then((value) {
                      if (value) {
                        _currentIndex = index;
                      } else {
                        Alert.showConnectionAlert();
                        _currentIndex = 1;
                      }
                    });
                  });
                } else {
                  scaffoldKey.currentState.openEndDrawer();
                }
              },
              items: [
                BottomNavigationBarItem(
                    title: Text(
                      'Companies',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.store,
                      color: Colors.white,
                    )),
                BottomNavigationBarItem(
                    title: Text('Shopping Lists',
                        style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.shop, color: Colors.white)),
                BottomNavigationBarItem(
                    title:
                        Text('Settings', style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.settings, color: Colors.white))
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Store store = StoreProvider.of<AppState>(context);
    return FutureBuilder(
      future: this._fetchData(store),
      builder: (
        context,
        AsyncSnapshot<dynamic> snapshot,
      ) {
        if (!snapshot.hasData) {
          return WaitScreen(
            title: 'KOAL',
          );
        }

        if (snapshot.data.every((result) => result == true)) {
          return screen();
        }
        return screen();
      },
    );
  }
}
