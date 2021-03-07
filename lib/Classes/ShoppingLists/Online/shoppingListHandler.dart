import 'dart:convert';
import 'dart:io';

import 'package:thesis/Classes/company.dart';
import 'package:thesis/Classes/ShoppingLists/Offline/offlineShoppingListHandler.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListItem.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_api_middleware/redux_api_middleware.dart';
import 'package:http/http.dart' as http;
import 'package:thesis/SharedComponents/alertDialog.dart';

class ShoppingListHandler {
  final List<ShoppingListItem> shoppingList;
  final List<ShoppingListItem> updatedList = [];
  final Store<AppState> storeProvider;
  OfflineShoppingListHandler offlineShoppingListHandler =
      OfflineShoppingListHandler();

  ShoppingListHandler(this.shoppingList, this.storeProvider);

  //ADD----------------------------------------------------------------

  //Post List Request
  Future<ShoppingListItem> postListItem(Map map) async {
    try {
      final response = await dio.post('shopping-list-items/',
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader:
                  "Token " + storeProvider.state.authToken,
              HttpHeaders.contentTypeHeader: 'application/json'
            },
          ),
          data: json.encode(map));

      if (response.statusCode == 201) {
        return ShoppingListItem.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      Alert.showConnectionAlert();
    }
  }

  //Add List Item
  Future<bool> addItemToList(ShoppingListItem item) async {
    int listIndex = storeProvider.state.shoppingLists.indexWhere(
        (shoppingList) =>
            shoppingList.id == storeProvider.state.currentShoppingList);
    Map itemMap = item.toMapAdd();
    final future = await this.postListItem(itemMap);
    if (future != null) {
      await this.offlineShoppingListHandler.setupOfflineHandler(true);
      this.offlineShoppingListHandler.addItemToList(listIndex, future);
      storeProvider.dispatch(AddItemAction(future, listIndex));

      return true;
    } else {
      return false;
    }
  }

  //ADD----------------------------------------------------------------

  //DELETE-----------------------------------------------------------------------

  // Delete Item  Request
  Future<bool> deleteListItem(ShoppingListItem item) async {
    try {
      final response = await dio.delete('shopping-list-items/${item.id}/',
          options: Options(headers: {
            HttpHeaders.authorizationHeader:
                "Token " + storeProvider.state.authToken,
            HttpHeaders.contentTypeHeader: 'application/json'
          }));
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      Alert.showConnectionAlert();
    }
  }

  //Delete List Item
  Future<bool> deleteItemFromList(ShoppingListItem item, int Index) async {
    int listIndex = storeProvider.state.shoppingLists.indexWhere(
        (shoppingList) =>
            shoppingList.id == storeProvider.state.currentShoppingList);
    final future = await this.deleteListItem(item);

    if (future) {
      await this.offlineShoppingListHandler.setupOfflineHandler(true);
      this.offlineShoppingListHandler.deleteFromList(listIndex, Index);
      storeProvider.dispatch(DeleteItemAction(item, listIndex, Index));
      return true;
    } else {
      return false;
    }
  }

  //DELETE-----------------------------------------------------------------------

  //UPDATE--------------------------------------------------------------------------

  //Update Item Request
  Future<bool> updateListItem(ShoppingListItem item) async {
    try {
      Map map = item.toMapUpdate();
      final response = await dio.put('shopping-list-items/${item.id}/',
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader:
                  "Token " + storeProvider.state.authToken,
              HttpHeaders.contentTypeHeader: 'application/json'
            },
          ),
          data: json.encode(map));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      Alert.showConnectionAlert();
    }
  }

  //Update List Item
  Future<bool> updateList(
      ShoppingListItem item, int index, bool isChecked) async {
    int listIndex = storeProvider.state.shoppingLists.indexWhere(
        (shoppingList) =>
            shoppingList.id == storeProvider.state.currentShoppingList);
    final future = await this.updateListItem(item);
    if (future) {
      await this.offlineShoppingListHandler.setupOfflineHandler(true);
      if (isChecked) {
        this
            .offlineShoppingListHandler
            .updateListItemCheck(listIndex, index, item);
        storeProvider.dispatch(UpdateItemCheckAction(item, listIndex, index));
        return true;
      } else {
        this
            .offlineShoppingListHandler
            .updateListItemUnCheck(listIndex, index, item);
        storeProvider.dispatch(UpdateItemUncheckAction(item, listIndex, index));
        return true;
      }
    } else {
      return false;
    }
  }

  //Check List Item
  checkItemFromList(ShoppingListItem item, int Index) async {
    int listIndex = storeProvider.state.shoppingLists.indexWhere(
        (shoppingList) =>
            shoppingList.id == storeProvider.state.currentShoppingList);
    final future = await this.deleteListItem(item);

    if (future) {
      await this.offlineShoppingListHandler.setupOfflineHandler(true);
      storeProvider.dispatch(DeleteItemAction(item, listIndex, Index));
    } else {
      return false;
    }
  }

//UPDATE--------------------------------------------------------------------------

}
