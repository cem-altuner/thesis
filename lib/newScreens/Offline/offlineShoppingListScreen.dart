import 'package:getwidget/getwidget.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:thesis/Classes/ShoppingLists/Offline/offlineShoppingListHandler.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListItem.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListHandler.dart';
import 'package:thesis/SharedComponents/waitScreen.dart';
import 'package:thesis/keys/myKeys.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:connectivity/connectivity.dart';

class OfflineShoppingListScreen extends StatefulWidget {
  final int currentListIndex;

  OfflineShoppingListScreen({Key key, this.currentListIndex}) : super(key: key);

  @override
  _OfflineShoppingListScreenState createState() =>
      _OfflineShoppingListScreenState();
}

class _OfflineShoppingListScreenState extends State<OfflineShoppingListScreen> {
  Future<bool> future;
  final _formKeyItem = GlobalKey<FormState>();
  final textController = TextEditingController();

  String ItemName = "";
  ScrollController _controller;

  OfflineShoppingListHandler offlineHandler;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(initialScrollOffset: 0);
    this.offlineHandler = OfflineShoppingListHandler();
  }

  //ADD SHOPPING LIST ITEM TILE
  Widget addShoppingListItemTile() {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
        child: Icon(
          Icons.add_shopping_cart,
          color: Colors.black,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      title: form(),
      trailing: GFButton(
        shape: GFButtonShape.pills,
        color: Colors.black54,
        type: GFButtonType.outline2x,
        child: Icon(Icons.add),
        textStyle: kButtonTextStyle,
        onPressed: () {
          if (_formKeyItem.currentState.validate()) {
            setState(() {
              this.offlineHandler.addItemToList(widget.currentListIndex,
                  ShoppingListItem(product: this.textController.text));
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
  Widget itemTile(int index) {
    ShoppingListItem item = this
        .offlineHandler
        .shoppingLists[widget.currentListIndex]
        .shoppingList[index];
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
            child: Text(item.product,
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
                  var offset = this._controller.offset;
                  this
                      .offlineHandler
                      .deleteFromList(widget.currentListIndex, index);

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
                      this.offlineHandler.updateListItem(
                          widget.currentListIndex, item, index, item.isChecked);
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
            contentPadding: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 0.0),
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
    return FutureBuilder(
        future: this.offlineHandler.setupOfflineHandler(false),
        builder: (
          context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GFLoader(type: GFLoaderType.circle);
          }
          if (this
                  .offlineHandler
                  .shoppingLists[widget.currentListIndex]
                  .shoppingList
                  .length !=
              0) {
            return ListView.separated(
                controller: _controller,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.transparent,
                    ),
                itemCount: this
                    .offlineHandler
                    .shoppingLists[widget.currentListIndex]
                    .shoppingList
                    .length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: kShoppingListsTileDecorationStyle,
                      child: itemTile(index));
                });
          } else {
            return Center(
              child: Text(
                'Touch + Button for adding Shopping List Item',
                style: kLabelStyle,
              ),
            );
          }
        });
  }

  //MAIN SCREEN
  Widget screen() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: GFAppBar(
            centerTitle: true,
            backgroundColor: Color(0xFF3F475F),
            title: Text("Offline Mode")),
        body: screen());
  }
}
