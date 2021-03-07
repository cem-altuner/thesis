import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:thesis/Classes/catalog.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListItem.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListHandler.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/SharedComponents/alertDialog.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:redux/redux.dart';
import 'package:thesis/model/appState.dart';
import 'package:flutter_picker/flutter_picker.dart';

class CatalogTemp extends StatefulWidget {
  @override
  _CatalogTemp createState() => new _CatalogTemp();
}

class _CatalogTemp extends State<CatalogTemp> {
  ShoppingList dropdownValue;
  String path;
  AsyncMemoizer _memorizer = AsyncMemoizer<bool>();

  final textController = TextEditingController();
  final _formKeyItemShoppingLists = GlobalKey<FormState>();

  String itemName = "";
  ShoppingListHandler _listHandler;
  ShoppingList _selectedList;
  String _string = "Touch blue shopping chart for select";

  //PDF CONF--------------------------------------------------------
  _fetchData() {
    return this._memorizer.runOnce(() async {
      return await this.loadPdf();
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Uint8List> fetchPost(String url) async {
    final response = await http.get(url);
    final responseJson = response.bodyBytes;
    return responseJson;
  }

  Future<bool> loadPdf() async {
    final int currentListID =
        StoreProvider.of<AppState>(context).state.currentCatalog;
    final int currentIndex = StoreProvider.of<AppState>(context)
        .state
        .catalogList
        .indexWhere((catalog) => catalog.id == currentListID);
    final Catalog currentCatalog =
        StoreProvider.of<AppState>(context).state.catalogList[currentIndex];
    await writeCounter(await fetchPost(
      currentCatalog.pdf_url.replaceAll("/api/catalogs", ""),
    ));
    await existsFile();
    path = (await _localFile).path;

    if (!mounted) return false;

    setState(() {});
    return true;
  }

  //PDF CONF--------------------------------------------------------

  //Picker
  showPicker(BuildContext context, String pickerData) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: JsonDecoder().convert(pickerData), isArray: true),
        hideHeader: true,
        title: Text('Select'),
        changeToFirst: true,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          Store store = StoreProvider.of<AppState>(context);
          setState(() {
            _selectedList = store.state.shoppingLists[value[0]];
            _listHandler = ShoppingListHandler(
                store.state.shoppingLists[value[0]].shoppingList,
                StoreProvider.of<AppState>(context));
            _string = "Selected List: " + _selectedList.name;
          });
          store.dispatch(changeCurrentShoppingListAction(_selectedList.id));
        }).showDialog(context);
  }

  //Shopping List Add tile form
  Widget form() {
    AppState state = StoreProvider.of<AppState>(context).state;
    String pickerData =
        '''[ ${state.shoppingLists.map((title) => '"${title.name}"').toList()}]''';

    return Container(
        margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
        height: 90.0,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                height: 70.0,
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
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: InkWell(
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      onTap: () {
                        state.shoppingLists.length > 0
                            ? showPicker(context, pickerData)
                            : Alert.showCatalog();
                      },
                    )))
          ],
        ));
  }

  //ADD SHOPPING LIST ITEM TILE
  Widget addShoppingListItemTile() {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      title: form(),
      trailing: Container(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: GFButton(
          buttonBoxShadow: true,
          shape: GFButtonShape.pills,
          color: Color(0XFF03DAC5),
          type: GFButtonType.solid,
          child: Icon(Icons.add),
          textStyle: kButtonTextStyle,
          onPressed: () {
            if (_formKeyItemShoppingLists.currentState.validate()) {
              if (this._selectedList != null) {
                this._listHandler.addItemToList(ShoppingListItem(
                    product: this.textController.text,
                    shoppingListId: StoreProvider.of<AppState>(context)
                        .state
                        .currentShoppingList));
              } else {}
            }
            this.setState(() {
              this.textController.clear();
            });
          },
        ),
      ),
    );
  }

  //Screen
  Widget screen() {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: GFAppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF4527A0),
        title: Text("Catalog"),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Text(
                    _string,
                    textAlign: TextAlign.center,
                    style: kTextTextStyle,
                  ),
                  addShoppingListItemTile(),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: PdfView(
                        path: path,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._fetchData(),
      builder: (
        context,
        AsyncSnapshot<bool> snapshot,
      ) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: GFAppBar(
                  centerTitle: true,
                  backgroundColor: Color(0xFF4527A0),
                  title: Text("Catalog")),
              body: GFLoader(type: GFLoaderType.circle));
        }

        if (snapshot.data == false) {
          return Container(
            child: Text('anan'),
          );
        }
        return screen();
      },
    );
  }
}
