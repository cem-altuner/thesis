import 'package:flutter/cupertino.dart';

class ShopTabNavigationService {
  final GlobalKey<NavigatorState> shopTabNavigatorKey;

  ShopTabNavigationService(this.shopTabNavigatorKey);

  Future<dynamic> navigateTo(String routeName) {
    return shopTabNavigatorKey.currentState.pushNamed(routeName);
  }

  void shoppingTabPopUntil1() {
    if (shopTabNavigatorKey.currentState != null) {
      if (shopTabNavigatorKey.currentState.canPop()) {
        shopTabNavigatorKey.currentState.popUntil((route) => route.isFirst);
      }
    }
  }
}
