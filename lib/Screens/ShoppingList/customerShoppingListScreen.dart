import 'package:thesis/Classes/ShoppingLists/Offline/offlineShoppingListHandler.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListItem.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListHandler.dart';
import 'package:thesis/SharedComponents/waitScreen.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

class CustomerShoppingListScreen extends StatefulWidget {
  @override
  _CustomerShoppingListScreenState createState() =>
      _CustomerShoppingListScreenState();
}

class _CustomerShoppingListScreenState
    extends State<CustomerShoppingListScreen> {
  Future<bool> future;
  final _formKeyItem = GlobalKey<FormState>();
  final textController = TextEditingController();
  ScrollController _controller;

  String ItemName = "";
  ShoppingListHandler _listHandler;
  OfflineShoppingListHandler offlineShoppingListHandler =
      OfflineShoppingListHandler();

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: 0);
    this._listHandler;
    this.offlineShoppingListHandler.setupOfflineHandler(true);
  }

  //ADD SHOPPING LIST ITEM TILE
  Widget addShoppingListItemTile() {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.fromLTRB(5.0, 12.0, 0.0, 0.0),
        child: Icon(
          Icons.add_shopping_cart,
          color: Colors.black,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      title: form(),
      trailing: GFButton(
        buttonBoxShadow: true,
        shape: GFButtonShape.pills,
        color: Color(0XFF03DAC5),
        type: GFButtonType.solid,
        child: Icon(
          Icons.add,
          color: Colors.black54,
        ),
        textStyle: kButtonTextStyle,
        onPressed: () {
          if (_formKeyItem.currentState.validate()) {
            setState(() {
              this.future = null;
              this.future = this._listHandler.addItemToList(ShoppingListItem(
                  product: this.textController.text,
                  shoppingListId: StoreProvider.of<AppState>(context)
                      .state
                      .currentShoppingList));
            });
          }
          this.setState(() {
            this.textController.clear();
          });
        },
      ),
    );
  }

  //SHOPPING LIST ITEM TILE
  Widget itemTile(ShoppingListItem item, int index) {
    TextDecoration decoration;
    if (item.isChecked) {
      decoration = TextDecoration.lineThrough;
    } else {
      decoration = TextDecoration.none;
    }

    return Container(
      decoration: tileDecoration,
      height: 70.0,
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(_listHandler.shoppingList[index].product,
                style: TextStyle(
                  decoration: decoration,
                  decorationThickness: 2.0,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            flex: 10,
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              child: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  if (_controller.hasClients) {
                    var offset = this._controller.offset;
                    future = _listHandler.deleteItemFromList(item, index);
                    if (this._controller.offset !=
                        this._controller.position.maxScrollExtent) {
                      this._controller =
                          new ScrollController(initialScrollOffset: offset);
                    } else if (this._controller.offset != 0) {
                      this._controller = new ScrollController(
                          initialScrollOffset: offset - 80.5);
                    } else {
                      this._controller =
                          new ScrollController(initialScrollOffset: 0);
                    }
                  } else {
                    future = _listHandler.deleteItemFromList(item, index);
                  }
                });
              },
            ),
          ),
          Expanded(
              child: Checkbox(
                  value: item.isChecked,
                  onChanged: (bool value) {
                    setState(() {
                      item.isChecked = !item.isChecked;
                      future = _listHandler.updateList(item, index, value);
                    });
                  }),
              flex: 2),
        ],
      ),
    );
  }

  //ADD SHOPPING LIST ITEM TILE
  Widget form() {
    return Container(
      height: 90.0,
      child: Form(
        key: _formKeyItem,
        child: TextFormField(
          controller: this.textController,
          validator: (val) => val.isEmpty ? "Enter an Item" : null,
          onChanged: (val) {},
          keyboardType: TextInputType.emailAddress,
          style: kFormTextStyle,
          decoration: InputDecoration(
            errorStyle: kErrorTextStyle,
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
            hintText: 'Enter your Item',
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
    );
  }

  //SCREEN BACKGROUND
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

  Widget ShoppingListView() {
    if (future != null) {
      return new FutureBuilder(
          future: future,
          builder: (
            context,
            AsyncSnapshot<bool> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GFLoader(type: GFLoaderType.circle);
            }
            if (_listHandler.shoppingList.length != 0) {
              return ListView.separated(
                  controller: _controller,
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.transparent,
                      ),
                  itemCount: _listHandler.shoppingList.length,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: kShoppingListsTileDecorationStyle,
                        margin: EdgeInsets.all(5.0),
                        child:
                            itemTile(_listHandler.shoppingList[index], index));
                  });
            } else {
              return Center(
                child: Text('Touch + Button for adding Shopping List'),
              );
            }
          });
    } else {
      if (_listHandler.shoppingList.length != 0) {
        return ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                ),
            itemCount: _listHandler.shoppingList.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: kShoppingListsTileDecorationStyle,
                  margin: EdgeInsets.all(5.0),
                  child: itemTile(_listHandler.shoppingList[index], index));
            });
      } else {
        return Center(
          child: Text(
            'Touch + Button for adding Shopping List Item',
            style: kLabelStyle,
          ),
        );
      }
    }
  }

  //MAIN SCREEN
  Widget screen() {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          Store store = StoreProvider.of<AppState>(context);
          int listIndex = state.shoppingLists
              .indexWhere((list) => list.id == state.currentShoppingList);
          List<ShoppingListItem> list =
              state.shoppingLists[listIndex].shoppingList;
          this._listHandler = ShoppingListHandler(list, store);
          return Stack(children: <Widget>[
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
                          child: addShoppingListItemTile()),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ShoppingListView())
                    ],
                  ),
                ))
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
            centerTitle: true,
            backgroundColor: Color(0xFF4527A0),
            title: Text("Shopping List")),
        body: screen());
  }
}
