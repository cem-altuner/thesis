import 'dart:convert';
import 'dart:io';

import 'package:thesis/Classes/catalog.dart';
import 'package:thesis/Classes/company.dart';
import 'package:thesis/Classes/customer.dart';
import 'package:thesis/Classes/ShoppingLists/Offline/offlineShoppingListHandler.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

//Fetch Customer
Future<bool> fCustomer(Store store) async {
  AppState state = store.state;
  String tokenHeader = "Token " + state.authToken;
  final response = await dio.get(
    'customers/',
    options: Options(headers: {
      HttpHeaders.authorizationHeader: tokenHeader,
      HttpHeaders.contentTypeHeader: 'application/json'
    }),
  );
  if (response.statusCode == 200) {
    final jsonResponse = response.data;
    Customer customer = Customer.fromJson(jsonResponse);
    store.dispatch((changeCurrentCustomer(customer)));
    return true;
  } else {
    return false;
  }
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
    offlineResponse = await pList(store);
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

//Fetch Companies
Future<bool> fCompanies(Store store) async {
  final response = await dio.get('companies/');
  AppState state = store.state;
  if (response.statusCode == 200) {
    List jsonResponse = response.data;
    List<Company> companyList =
        jsonResponse.map((company) => Company.fromJson(company)).toList();
    store.dispatch(changeCompanyList(companyList));
    return true;
  } else {
    return false;
  }
}

//Fetch Catalogs
Future<bool> fCatalogs(Store store) async {
  final response = await dio.get('catalogs/');
  AppState state = store.state;
  if (response.statusCode == 200) {
    List jsonResponse = response.data;
    List<Catalog> catalogList =
        jsonResponse.map((company) => Catalog.fromJson(company)).toList();
    store.dispatch(changeCatalogList(catalogList));
    return true;
  } else {
    return false;
  }
}

//Post Offline Lists
Future<bool> pList(Store store) async {
  OfflineShoppingListHandler offlineHandler = OfflineShoppingListHandler();
  AppState state = store.state;
  String tokenHeader = "Token " + state.authToken;
  await offlineHandler
      .setupOfflineHandler(true)
      .whenComplete(() => offlineHandler.deleteOfflineData());
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
  } else {
    return false;
  }
}
