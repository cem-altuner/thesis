import 'package:thesis/Screens/Catalog/catalogPdfTemp.dart';

import 'package:thesis/Screens/Company/companyGridNavigationService.dart';
import 'package:thesis/Screens/Company/companyGridScreen.dart';

import 'package:flutter/material.dart';

class CompanyTabScreenBuilder extends StatelessWidget {
  CompanyTabScreenBuilder(this.service);

  final CompanyTabNavigationService service;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'companies',
      key: service.companyNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'companies':
            return MaterialPageRoute(
                builder: (context) => CompanyGridScreen(), settings: settings);
            break;

          case 'catalog':
            return MaterialPageRoute(
                builder: (context) => CatalogTemp(), settings: settings);
            break;
          default:
            throw Exception("Invalid route");
        }
      },
    );
  }
}
