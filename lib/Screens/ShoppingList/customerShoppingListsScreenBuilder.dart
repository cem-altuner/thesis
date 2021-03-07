import 'package:thesis/Screens/ShoppingList/customerShoppingListScreen.dart';
import 'package:thesis/Screens/ShoppingList/customerShoppingListsScreen.dart';
import 'package:thesis/Screens/ShoppingList/shoppingListTabNavigationService.dart';
import 'package:flutter/material.dart';

class CustomerShoppingListsBuilder extends StatelessWidget {
  CustomerShoppingListsBuilder(this.service);

  final ShopTabNavigationService service;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'shoppingLists',
      key: service.shopTabNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        print(settings.name);
        switch (settings.name) {
          case 'shoppingList':
            return MaterialPageRoute(
                builder: (context) => CustomerShoppingListScreen(),
                settings: settings);
            break;

          case 'shoppingLists':
            return MaterialPageRoute(
                builder: (context) => CustomerShoppingListsScreen(),
                settings: settings);
            break;
          default:
            throw Exception("Invalid route");
        }
      },
    );
  }
}
