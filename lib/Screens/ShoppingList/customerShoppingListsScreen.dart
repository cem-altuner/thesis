import 'dart:io';

import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:thesis/Classes/ShoppingLists/Offline/offlineShoppingListHandler.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListsHandler.dart';
import 'package:thesis/Network/network_bloc.dart';
import 'package:thesis/Network/network_event.dart';
import 'package:thesis/Network/network_state.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/SharedComponents/waitScreen.dart';
import 'package:thesis/keys/myKeys.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/services/dio.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis/Screens/Offline/offlineScreen.dart';

class CustomerShoppingListsScreen extends StatefulWidget {
  @override
  _CustomerShoppingListsScreenState createState() =>
      _CustomerShoppingListsScreenState();
}

class _CustomerShoppingListsScreenState
    extends State<CustomerShoppingListsScreen> {
  Future future;
  ShoppingListsHandler _listsHandler;
  final _formKeyItemShoppingLists = GlobalKey<FormState>();
  final textController = TextEditingController();
  ScrollController _controller;

  OfflineShoppingListHandler offlineShoppingListHandler =
      OfflineShoppingListHandler();

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: 0);
    this.offlineShoppingListHandler.setupOfflineHandler(true);
  }

  // ignore: non_constant_identifier_names
  int compare_list_items(a, b) {
    if (a.isChecked) {
      return 1;
    } else {
      return -1;
    }
  }

  //Fetch Shopping Lists
  Future<bool> fList(Store store) async {
    OfflineShoppingListHandler offlineHandler = OfflineShoppingListHandler();
    AppState state = store.state;
    String tokenHeader = "Token " + state.authToken;
    await offlineHandler.setupOfflineHandler(true);
    bool offlineResponse;
    if (offlineHandler.offlineChanged == true) {
      offlineResponse = await pListRecursive(store);
    } else {
      offlineResponse = true;
    }
    if (offlineResponse) {
      final response = await dio.get('shopping-list/',
          options: Options(headers: {
            HttpHeaders.authorizationHeader: tokenHeader,
            HttpHeaders.contentTypeHeader: 'application/json'
          }));
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        offlineHandler.changeOfflineContent(jsonResponse);
        List<ShoppingList> myList = jsonResponse
            .map<ShoppingList>((item) => ShoppingList.fromJson(item))
            .toList();
        myList.forEach((element) =>
            {element.shoppingList.sort((a, b) => compare_list_items(a, b))});
        store.dispatch(changeShoppingLists(myList));
        return true;
      } else {
        return false;
      }
    }
  }

//Post Offline Lists
  Future<bool> pListRecursive(Store store) async {
    OfflineShoppingListHandler offlineHandler = OfflineShoppingListHandler();
    AppState state = store.state;
    String tokenHeader = "Token " + state.authToken;
    await offlineHandler.setupOfflineHandler(true);
    List<Map<String, dynamic>> list = [];
    offlineHandler.shoppingLists.forEach((ShoppingList shoppingList) =>
        shoppingList.isChangedOffline == true
            ? list.add(shoppingList.toMapOnline())
            : print("There is a problem in Api Service 124"));
    offlineHandler.shoppingLists.forEach((element) {
      (ShoppingList list) =>
          list.shoppingList.forEach((element) => {print(element.id)});
    });
    offlineHandler.deletedShoppingLists.forEach(
        (ShoppingList shoppingList) => shoppingList.isChangedOffline == true
            ? list.add(
                shoppingList.toMapOnline(),
              )
            : print("There is a problem in Api Service 124"));
    final response = await dio.post('shopping-list/',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: tokenHeader,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
        ),
        data: list);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await offlineHandler
          .setupOfflineHandler(true)
          .whenComplete(() => offlineHandler.deleteDeletedLists());
      return true;
    } else {}
  }

  //Shopping List Add tile form
  Widget form() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
      height: 90.0,
      child: Form(
        key: _formKeyItemShoppingLists,
        child: TextFormField(
          controller: this.textController,
          validator: (val) => val.isEmpty ? "Enter a Name" : null,
          onChanged: (val) {},
          keyboardType: TextInputType.emailAddress,
          style: kFormTextStyle,
          decoration: InputDecoration(
            errorStyle: kErrorTextStyle,
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
            hintText: 'Enter list name',
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
    );
  }

  //Add Shopping List Tile Button
  Widget addButton() {
    return GFButton(
      buttonBoxShadow: true,
      shape: GFButtonShape.pills,
      color: Color(0XFF03DAC5),
      type: GFButtonType.solid,
      child: Icon(
        Icons.add,
        color: Colors.black54,
      ),
      textStyle: kButtonTextStyle,
      onPressed: () async {
        if (_formKeyItemShoppingLists.currentState.validate()) {
          setState(() {
            this.future = null;
            future =
                this._listsHandler.addShoppingListToList(textController.text);
          });
        }
        this.setState(() {
          this.textController.clear();
        });
      },
    );
  }

  //Shopping List Add tile
  Widget addShoppingListTile() {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 15.0, 0.0),
      title: form(),
      trailing: addButton(),
    );
  }

  //Shopping List Item Tile Button
  Widget tileButton(List<ShoppingList> shoppingListLists, int index) {
    return GFButton(
      shape: GFButtonShape.pills,
      color: Colors.black54,
      type: GFButtonType.outline2x,
      text: "Show",
      textStyle: kButtonTextStyle,
      onPressed: () {
        StoreProvider.of<AppState>(context).dispatch(
            changeCurrentShoppingListAction(shoppingListLists[index].id));
        Navigator.pushNamed(context, 'shoppingList');
      },
    );
  }

  //SHOPPING LIST ITEM TILE
  Widget shoppingListTile(List<ShoppingList> shoppingListLists, int index) {
    return Container(
      decoration: tileDecoration,
      height: 70.0,
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 12,
            child: InkWell(
              onTap: () {
                StoreProvider.of<AppState>(context).dispatch(
                    changeCurrentShoppingListAction(
                        shoppingListLists[index].id));
                Navigator.pushNamed(context, 'shoppingList');
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                      child: Icon(
                        Icons.shopping_cart,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 70.0,
                      padding: EdgeInsets.fromLTRB(5.0, 25.0, 0.0, 0.0),
                      child: Text(this._listsHandler.shoppingLists[index].name,
                          style: kTextTextStyle),
                    ),
                    flex: 10,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              child: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  var offset = 0.0;
                  if (_controller.hasClients) {
                    var offset = this._controller.offset;
                    this.future = this
                        ._listsHandler
                        .deleteListFromList(shoppingListLists[index]);
                    if (this._controller.offset !=
                        this._controller.position.maxScrollExtent) {
                      this._controller =
                          new ScrollController(initialScrollOffset: offset);
                    } else if (this._controller.offset != 0) {
                      this._controller = new ScrollController(
                          initialScrollOffset: offset - 86.0);
                    } else {
                      this._controller =
                          new ScrollController(initialScrollOffset: 0);
                    }
                  } else {
                    this.future = this
                        ._listsHandler
                        .deleteListFromList(shoppingListLists[index]);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget shoppingListsScreen() {
    if (future != null) {
      return FutureBuilder(
        future: future,
        builder: (
          context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GFLoader(type: GFLoaderType.circle);
          }
          if (this._listsHandler.shoppingLists.length != 0) {
            return ListView.separated(
                controller: _controller,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.transparent,
                    ),
                itemCount: this._listsHandler.shoppingLists.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: kShoppingListsTileDecorationStyle,
                    child: shoppingListTile(
                        this._listsHandler.shoppingLists, index),
                  );
                });
          } else {
            return Center(
              child: Text(
                'Touch + Button for adding Shopping List ',
                style: kLabelStyle,
              ),
            );
          }
        },
      );
    } else {
      if (this._listsHandler.shoppingLists.length != 0) {
        _listsHandler.shoppingLists.sort((b, a) => (a.id).compareTo(b.id));

        return ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                ),
            itemCount: this._listsHandler.shoppingLists.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: kShoppingListsTileDecorationStyle,
                child:
                    shoppingListTile(this._listsHandler.shoppingLists, index),
              );
            });
      } else {
        return Center(
          child: Text(
            'Touch + Button for adding Shopping List ',
            style: kLabelStyle,
          ),
        );
      }
    }
  }

  Widget screenBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
    );
  }

  //Main Screen
  Widget screen() {
    List<ShoppingList> shoppingListLists;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          this._listsHandler = ShoppingListsHandler(
              state.shoppingLists, StoreProvider.of<AppState>(context));
          return Stack(
            children: <Widget>[
              screenBackground(),
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 50.0),
                        Container(
                          decoration: kAddShoppingListsTileDecorationStyle,
                          child: addShoppingListTile(),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: shoppingListsScreen(),
                        ),
                      ],
                    ),
                  ))
            ],
          );
        });
  }

  Widget futureScreen() {
    Store store = StoreProvider.of<AppState>(context);
    return FutureBuilder(
      future: this.fList(store),
      builder: (
        context,
        AsyncSnapshot<dynamic> snapshot,
      ) {
        if (!snapshot.hasData) {
          return Center(child: GFLoader(type: GFLoaderType.circle));
        }

        if (snapshot.data == true) {
          return screen();
        }
        return OfflineScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: GFAppBar(
          elevation: 20.0,
          centerTitle: true,
          backgroundColor: Color(0xFF4527A0),
          title: Text("Shopping Lists")),
      body: BlocProvider(
        create: (context) => NetworkBloc()..add(ListenConnection()),
        child: BlocBuilder<NetworkBloc, NetworkState>(
          builder: (context, state) {
            if (state is ConnectionFailure) {
              return OfflineScreen();
            }
            ;
            if (state is ConnectionSuccess) {
              return futureScreen();
            } else
              return GFLoader(type: GFLoaderType.circle);
          },
        ),
      ),
    );
  }
}
