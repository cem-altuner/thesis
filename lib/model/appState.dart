import 'package:thesis/Classes/catalog.dart';
import 'package:thesis/Classes/company.dart';
import 'package:thesis/Classes/customer.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';

class AppState {
  List<ShoppingList> shoppingLists;
  int currentShoppingList;
  String authToken;
  List<Company> companyList;
  Customer currentCustomer;
  List<Catalog> catalogList;
  int currentCatalog;

  AppState(
      {this.shoppingLists,
      this.currentShoppingList,
      this.companyList,
      this.authToken});

  AppState.fromAppState(AppState another) {
    currentCustomer = another.currentCustomer;
    shoppingLists = another.shoppingLists;
    currentShoppingList = another.currentShoppingList;
    authToken = another.authToken;
    companyList = another.companyList;
    catalogList = another.catalogList;
    currentCatalog = another.currentCatalog;
  }

  List<ShoppingList> get getShoppingList => shoppingLists;
}
