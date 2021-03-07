import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis/Classes/authHandler.dart';
import 'package:thesis/Screens/Home/SplashScreen.dart';

import 'package:thesis/Screens/Login/loginScreen.dart';
import 'package:thesis/Screens/Login/registerScreen.dart';
import 'package:thesis/Screens/Offline/offlineScreen.dart';
import 'package:flutter/material.dart';
import 'package:thesis/model/appState.dart';

import 'package:thesis/Redux/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:thesis/keys/myKeys.dart';

import 'Network/network_bloc.dart';
import 'Network/network_event.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  AuthHandler authHandler = AuthHandler();
  String token = await authHandler.getAuthToken();
  bool result = token != null;
  String initialRoute = result ? '/splash' : '/login';

  final _initialState = AppState(currentShoppingList: 1, authToken: token);
  final Store<AppState> _store =
      Store<AppState>(reducer, initialState: _initialState);
  runApp(MyApp(
    store: _store,
    home: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  final String home;

  MyApp({this.store, this.home});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        navigatorKey: NoomiKeys.navKey,
        home: BlocProvider(
            create: (context) => NetworkBloc()..add(ListenConnection()),
            child:LoginScreen2()
        ),
        routes: <String, WidgetBuilder>{
          '/login' : (context) => LoginScreen2(),
          '/splash': (context) => SplashScreen(),
          '/register': (context) => RegisterScreen(),
          '/offline': (context) => OfflineScreen()
        },
      ),
    );
  }
}
