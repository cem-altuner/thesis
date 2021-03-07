import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingListItem.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/model/appState.dart';

AppState reducer(AppState prevState, dynamic action) {
  AppState newState = AppState.fromAppState(prevState);

  //Shopping List actions
  if (action is AddItemAction) {
    newState.shoppingLists = prevState.shoppingLists;
    newState.shoppingLists[action.shoppingListIndex].shoppingList
        .insert(0, action.item);
    return newState;
  } else if (action is changeCurrentShoppingListAction) {
    newState.currentShoppingList = action.index;

    return newState;
  } else if (action is changeShoppingLists) {
    newState.shoppingLists = action.shoppingLists;
    return newState;
  } else if (action is DeleteItemAction) {
    newState.shoppingLists[action.shoppingListIndex].shoppingList
        .removeAt(action.itemIndex);
    return newState;
  } else if (action is UpdateItemCheckAction) {
    newState.shoppingLists[action.shoppingListIndex].shoppingList
        .removeAt(action.itemIndex);
    newState.shoppingLists[action.shoppingListIndex].shoppingList
        .add(action.item);
    return newState;
  } else if (action is UpdateItemUncheckAction) {
    newState.shoppingLists[action.shoppingListIndex].shoppingList
        .removeAt(action.itemIndex);
    newState.shoppingLists[action.shoppingListIndex].shoppingList
        .insert(0, action.item);
    return newState;
  } else if (action is addShoppingList) {
    newState.shoppingLists.insert(0, action.list);
    return newState;
  } else if (action is deleteShoppingList) {
    newState.shoppingLists.removeAt(action.Index);
    return newState;
  }

  //Customer Actions
  else if (action is authTokenAction) {
    newState.authToken = action.authToken;
    return newState;
  } else if (action is changeCurrentCustomer) {
    newState.currentCustomer = action.customer;
    return newState;
  }

  //Company Actions
  else if (action is changeCompanyList) {
    newState.companyList = action.companyList;
    return newState;
  }

  // Catalog Actions
  else if (action is changeCatalogList) {
    newState.catalogList = action.catalogList;
    return newState;
  } else if (action is changeCurrentCatalog) {
    newState.currentCatalog = action.currentCatalogId;
    return newState;
  }
}
