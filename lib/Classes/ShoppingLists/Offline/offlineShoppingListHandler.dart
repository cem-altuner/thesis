import 'dart:core';

import 'package:flutter/material.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListItem.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class OfflineShoppingListHandler {
  bool is_online_changed = false;
  List<ShoppingList> shoppingLists;
  List<ShoppingList> deletedShoppingLists;
  File jsonFile;
  Directory dir;
  String fileName = "thesis.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  bool offlineChanged;

  OfflineShoppingListHandler();

  // Handler conf ------------------------------------------
  Future<void> setupOfflineHandler(bool is_online_changed) async {
    this.is_online_changed = is_online_changed;
    Directory directory = await getApplicationDocumentsDirectory();
    this.dir = directory;
    jsonFile = new File(dir.path + "/" + fileName);
    this.fileExists = jsonFile.existsSync();
    fileExists ? readAll() : await createDefaultFile();
  }

  Future createDefaultFile() {
    if (!fileExists) {
      print("Creating file!");
      print(this.dir.path);
      File file = new File(dir.path + "/" + fileName);
      file.createSync();
      fileExists = true;
      Map<String, dynamic> content = {
        'shoppingLists': [],
        'offlineChanged': false,
        'deletedShoppingLists': []
      };
      jsonFile.writeAsStringSync(json.encode(content));
    }
  }

  void readAll() {
    this.readOfflineChangeFlag();
    this.readThLists();
    this.readDeletedLists();
  }

  // Handler conf ------------------------------------------

  //Deleted Items---------------------------------

  void readDeletedLists() {
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      List jsonLists = jsonFileContent['deletedShoppingLists'];
      if (jsonLists.isNotEmpty) {
        List<ShoppingList> myList = jsonLists
            .map<ShoppingList>((item) => ShoppingList.fromJson(item))
            .toList();
        this.deletedShoppingLists = myList;
      } else {
        this.deletedShoppingLists = [];
      }
    }
  }

  void refreshDeletedShoppingLists() {
    if (fileExists) {
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent['deletedShoppingLists'] = this
          .deletedShoppingLists
          .map((shoppingList) => shoppingList.toMapOffline())
          .toList();
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
    }
    fileContent = json.decode(jsonFile.readAsStringSync());
    print(fileContent);
  }

  void deletedShoppingListsAdd(int shoppingListIndex) {
    this.deletedShoppingLists.add(this.shoppingLists[shoppingListIndex]);
    this.refreshDeletedShoppingLists();
  }

  void deleteDeletedLists() {
    this.deletedShoppingLists.clear();
    this.refreshDeletedShoppingLists();
  }

  //Deleted Items-----------------------------------------------

  //Shopping List------------------------------------------------

  void changeOfflineContent(List content) {
    if (fileExists) {
      this.changeShoppingLists(content);
    }
  }

  void readThLists() {
    if (fileExists) {
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      List jsonLists = jsonFileContent['shoppingLists'];
      if (jsonLists.isNotEmpty) {
        List<ShoppingList> myList = jsonLists
            .map<ShoppingList>((item) => ShoppingList.fromJson(item))
            .toList();
        this.shoppingLists = myList;
      } else {
        this.shoppingLists = [];
      }
    }
  }

  void refreshShoppingLists() {
    if (fileExists) {
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent['shoppingLists'] = this
          .shoppingLists
          .map((shoppingList) => shoppingList.toMapOffline())
          .toList();
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
    }
    fileContent = json.decode(jsonFile.readAsStringSync());
    print(fileContent);
  }

  void changeShoppingLists(List<dynamic> list) {
    if (fileExists) {
      jsonFile = new File(dir.path + "/" + fileName);
      jsonFile.readAsStringSync();
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent['shoppingLists'] = list;
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
    }
    fileContent = json.decode(jsonFile.readAsStringSync());
    print(fileContent);
  }

  void deleteFromList(int shoppingListIndex, int deletedItemIndex) {
    this.setOfflineChangeFlag();
    if (!this.is_online_changed) {
      this.shoppingLists[shoppingListIndex].isChangedOffline = true;
    }
    this
        .shoppingLists[shoppingListIndex]
        .shoppingList
        .removeAt(deletedItemIndex);
    this.refreshShoppingLists();
  }

  void addItemToList(int shoppingListIndex, ShoppingListItem item) {
    this.setOfflineChangeFlag();
    this.shoppingLists[shoppingListIndex].isChangedOffline = true;
    this.shoppingLists[shoppingListIndex].shoppingList.insert(0, item);
    this.refreshShoppingLists();
  }

  void addListToLists(ShoppingList list) {
    this.setOfflineChangeFlag();
    list.isChangedOffline = true;
    this.shoppingLists.insert(0, list);
    this.refreshShoppingLists();
  }

  void deleteListFromList(int shoppingListIndex, bool is_online_delete) {
    if (this.shoppingLists[shoppingListIndex].id != null && !is_online_delete) {
      this.shoppingLists[shoppingListIndex].isChangedOffline = true;
      this.shoppingLists[shoppingListIndex].isDeletedOffline = true;
      this.deletedShoppingListsAdd(shoppingListIndex);
      this.setOfflineChangeFlag();
    }
    this.shoppingLists.removeAt(shoppingListIndex);
    this.refreshShoppingLists();
  }

  void updateListItem(
      int shoppingListIndex, ShoppingListItem item, int index, bool isChecked) {
    this.setOfflineChangeFlag();
    this.shoppingLists[shoppingListIndex].isChangedOffline = true;
    if (isChecked) {
      this.updateListItemCheck(shoppingListIndex, index, item);
    } else {
      this.updateListItemUnCheck(shoppingListIndex, index, item);
    }
  }

  void updateListItemCheck(
      int shoppingListIndex, int itemIndex, ShoppingListItem item) {
    this.shoppingLists[shoppingListIndex].shoppingList.removeAt(itemIndex);
    this.shoppingLists[shoppingListIndex].shoppingList.add(item);
    this.refreshShoppingLists();
  }

  void updateListItemUnCheck(
      int shoppingListIndex, int itemIndex, ShoppingListItem item) {
    this.shoppingLists[shoppingListIndex].shoppingList.removeAt(itemIndex);
    this.shoppingLists[shoppingListIndex].shoppingList.insert(0, item);
    this.refreshShoppingLists();
  }

  void deleteOfflineData() async {
    jsonFile.deleteSync(recursive: true);
  }

  //Shopping List------------------------------------------------

  //Offline Changed----------------------------------------------

  void readOfflineChangeFlag() {
    if (fileExists) {
      bool offlineChangedFlag =
          json.decode(jsonFile.readAsStringSync())['offlineChanged'];
      this.offlineChanged = offlineChangedFlag;
    }
  }

  void setOfflineChangeFlag() {
    if (fileExists) {
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent['offlineChanged'] = true;
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
    }

    //Offline Changed----------------------------------------------
  }
}
