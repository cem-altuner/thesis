import 'package:thesis/Classes/catalog.dart';
import 'package:thesis/Classes/company.dart';
import 'package:thesis/Classes/customer.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListItem.dart';

//Shopping List Actions--------------------------------------
class AddItemAction {
  final ShoppingListItem item;
  final int shoppingListIndex;

  AddItemAction(this.item, this.shoppingListIndex);
}

class DeleteItemAction {
  final ShoppingListItem item;
  final int shoppingListIndex;
  final int itemIndex;

  DeleteItemAction(this.item, this.shoppingListIndex, this.itemIndex);
}

class UpdateItemCheckAction {
  final ShoppingListItem item;
  final int shoppingListIndex;
  final int itemIndex;

  UpdateItemCheckAction(this.item, this.shoppingListIndex, this.itemIndex);
}

class UpdateItemUncheckAction {
  final ShoppingListItem item;
  final int shoppingListIndex;
  final int itemIndex;

  UpdateItemUncheckAction(this.item, this.shoppingListIndex, this.itemIndex);
}

class CheckItemAction {
  final ShoppingListItem item;
  final int shoppingListIndex;
  final int itemIndex;

  CheckItemAction(this.item, this.shoppingListIndex, this.itemIndex);
}

class changeCurrentShoppingListAction {
  final int index;

  changeCurrentShoppingListAction(this.index);
}

class changeShoppingLists {
  final List<ShoppingList> shoppingLists;

  changeShoppingLists(this.shoppingLists);
}

class addShoppingList {
  final ShoppingList list;

  addShoppingList(this.list);
}

class deleteShoppingList {
  final int Index;

  deleteShoppingList(this.Index);
}

//Shopping List Actions--------------------------------------

//Customer Company Actions-----------------------------------
class authTokenAction {
  final String authToken;

  authTokenAction(this.authToken);
}

class changeCompanyList {
  final List<Company> companyList;

  changeCompanyList(this.companyList);
}

class changeCurrentCustomer {
  final Customer customer;

  changeCurrentCustomer(this.customer);
}

//Customer Company Actions-----------------------------------

//Catalog Actions--------------------------------------------
class changeCatalogList {
  final List<Catalog> catalogList;

  changeCatalogList(this.catalogList);
}

class changeCurrentCatalog {
  final int currentCatalogId;

  changeCurrentCatalog(this.currentCatalogId);
}
//Catalog Actions--------------------------------------------
