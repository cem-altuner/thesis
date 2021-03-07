import 'package:flutter/cupertino.dart';
import 'package:thesis/SharedComponents/alertDialog.dart';

class CompanyTabNavigationService {
  final GlobalKey<NavigatorState> companyNavigatorKey;

  CompanyTabNavigationService(this.companyNavigatorKey);

  Future<dynamic> navigateTo(String routeName) {
    return companyNavigatorKey.currentState.pushNamed(routeName);
  }

  void companyTabPopUntil1() {
    if (companyNavigatorKey.currentState != null) {
      if (companyNavigatorKey.currentState.canPop()) {
        companyNavigatorKey.currentState.popUntil((route) => route.isFirst);
      }
    } else {
      print('will pop');
    }
  }
}
