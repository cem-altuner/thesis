import 'dart:convert';
import 'dart:io';

import 'package:thesis/Classes/company.dart';
import 'package:thesis/Classes/customer.dart';
import 'package:thesis/Classes/ShoppingLists/Online/shoppingList.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/model/appState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

class CustomerDetailScreen extends StatefulWidget {
  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Customer customer;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          customer = state.currentCustomer;
          return Container();
        });
  }
}
