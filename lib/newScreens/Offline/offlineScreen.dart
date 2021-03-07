import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:getwidget/getwidget.dart';
import 'package:thesis/Classes/ShoppingLists/Offline/offlineShoppingListHandler.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/SharedComponents/alertDialog.dart';
import 'package:thesis/keys/myKeys.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/newScreens/Offline/offlineShoppingListScreen.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:connectivity/connectivity.dart';

class OfflineScreen extends StatefulWidget {
  @override
  _OfflineScreenState createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  List<ShoppingList> shoppingLists;
  final textController = TextEditingController();
  final _formKeyItemShoppingLists = GlobalKey<FormState>();
  OfflineShoppingListHandler offlineHandler;
  ScrollController _controller;

  Future<bool> _checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(initialScrollOffset: 0);
    this.offlineHandler = OfflineShoppingListHandler();
  }

  //Shopping List Add tile form
  Widget form() {
    return Container(
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
            contentPadding: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 0.0),
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
      shape: GFButtonShape.pills,
      color: Colors.black54,
      type: GFButtonType.outline2x,
      child: Icon(Icons.add),
      textStyle: kButtonTextStyle,
      onPressed: () async {
        if (_formKeyItemShoppingLists.currentState.validate()) {
          setState(() {
            this._controller = ScrollController(initialScrollOffset: 0);
            this.offlineHandler.addListToLists(ShoppingList(
                name: this.textController.text, isChangedOffline: true));
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
      contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      title: form(),
      leading: Container(
        padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
        child: Icon(
          Icons.add_shopping_cart,
          color: Colors.black,
        ),
      ),
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
        onPressed: () {});
  }

  //SHOPPING LIST ITEM TILE
  Widget shoppingListTile(int index) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OfflineShoppingListScreen(currentListIndex: index)),
                );
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.shopping_cart, color: Colors.black),
                  ),
                  Expanded(
                    child: Container(
                      height: 70.0,
                      padding: EdgeInsets.fromLTRB(5.0, 25.0, 0.0, 0.0),
                      child: Text(this.offlineHandler.shoppingLists[index].name,
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
                  var offset = this._controller.offset;
                  this.offlineHandler.deleteListFromList(index, false);

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
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget shoppingListsScreen() {
    return FutureBuilder(
        future: this.offlineHandler.setupOfflineHandler(false),
        builder: (
          context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GFLoader(type: GFLoaderType.circle);
          }
          if (this.offlineHandler.shoppingLists.length != 0) {
            return ListView.separated(
                controller: this._controller,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.transparent,
                    ),
                itemCount: this.offlineHandler.shoppingLists.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: kShoppingListsTileDecorationStyle,
                    child: shoppingListTile(index),
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
        });
  }

  /*
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        itemCount: this.offlineHandler.shoppingLists.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: kShoppingListsTileDecorationStyle,
            child: shoppingListTile(index),
          );
        });*/

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

  Function function1 = () {
    NoomiKeys.navKey.currentState.popAndPushNamed('/splash');
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: GFAppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Online Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    bool result = await this._checkInternetConnection();
                    result ? function1() : Alert.showOfflineAlert();
                  },
                )
              ],
              centerTitle: true,
              backgroundColor: Color(0xFF3F475F),
              title: Text("Offline Mode")),
          body: screen()),
    );
  }
}
