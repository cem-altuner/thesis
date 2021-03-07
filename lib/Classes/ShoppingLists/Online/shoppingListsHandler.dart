import 'dart:convert';
import 'dart:io';
import 'package:thesis/Classes/ShoppingLists/Offline/offlineShoppingListHandler.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:thesis/SharedComponents/alertDialog.dart';

class ShoppingListsHandler {
  final List<ShoppingList> shoppingLists;
  final Store<AppState> storeProvider;
  final OfflineShoppingListHandler offlineShoppingListHandler =
      OfflineShoppingListHandler();

  ShoppingListsHandler(this.shoppingLists, this.storeProvider);

  Future<ShoppingList> postList(String listName) async {
    try {
      List<Map<String, dynamic>> map = [
        ShoppingList(
                name: listName,
                customerId: storeProvider.state.currentCustomer.uid)
            .toMapOffline()
      ];

      final response = await dio.post('shopping-list/',
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader:
                  "Token e1fc224c86260d784be0196ab5cd825bfb09d32a",
              HttpHeaders.contentTypeHeader: 'application/json'
            },
          ),
          data: json.encode(map));

      if (response.statusCode == 201) {
        return ShoppingList.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      Alert.showConnectionAlert();
    }
  }

  Future<bool> deleteList(ShoppingList list) async {
    try {
      final response = await dio.delete('shopping-list/',
          options: Options(headers: {
            HttpHeaders.authorizationHeader:
                "Token " + storeProvider.state.authToken,
            HttpHeaders.contentTypeHeader: 'application/json'
          }),
          data: {"id": list.id});
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      Alert.showConnectionAlert();
    }
  }

  Future<bool> deleteListFromList(ShoppingList list) async {
    bool is_online_delete;
    int listIndex = storeProvider.state.shoppingLists
        .indexWhere((shoppingList) => shoppingList.id == list.id);
    final future = await this.deleteList(list);
    if (future) {
      is_online_delete = true;
      await this.offlineShoppingListHandler.setupOfflineHandler(true);
      this
          .offlineShoppingListHandler
          .deleteListFromList(listIndex, is_online_delete);
      storeProvider.dispatch(deleteShoppingList(listIndex));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addShoppingListToList(String name) async {
    String listName = name;
    final future = await this.postList(listName);
    if (future != null) {
      await this.offlineShoppingListHandler.setupOfflineHandler(true);
      this.offlineShoppingListHandler.addListToLists(future);
      storeProvider.dispatch(addShoppingList(future));
      return true;
    } else {
      return false;
    }
  }
}
