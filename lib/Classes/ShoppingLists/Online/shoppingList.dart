import 'dart:convert';

import 'package:thesis/Classes/ShoppingLists/Online/shoppingListItem.dart';

class ShoppingList {
  final int id;
  final List<ShoppingListItem> shoppingList;
  final String name;
  final int customerId;
  bool isDeletedOffline;
  bool isChangedOffline;
  bool isDone;

  ShoppingList(
      {this.id,
      this.shoppingList = const [],
      this.name,
      this.customerId,
      this.isDone = false,
      this.isDeletedOffline = false,
      this.isChangedOffline = false});

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
        id: json['id'],
        shoppingList: json['shopping_list_items']
            .map<ShoppingListItem>((item) => ShoppingListItem.fromJson(item))
            .toList(),
        customerId: json['customer'],
        name: json['name'],
        isDone: json['isDone'],
        isDeletedOffline: json['is_deleted_offline'],
        isChangedOffline: json['is_changed_offline']);
  }

  Map toMapOffline() {
    var map = new Map<String, dynamic>();
    map["id"] = this.id != null ? this.id : null;
    map['customer'] = this.customerId;
    map["name"] = this.name;
    map['isDone'] = this.isDone;
    map['shopping_list_items'] =
        this.shoppingList.map((item) => item.toMapOffline()).toList();
    map['is_deleted_offline'] = this.isDeletedOffline;
    map['is_changed_offline'] = this.isChangedOffline;

    return map;
  }

  Map toMapOnline() {
    var map = new Map<String, dynamic>();
    map["id"] = this.id != null ? this.id : null;
    map['customer'] = this.customerId;
    map["name"] = this.name;
    map['isDone'] = this.isDone;
    map['shopping_list_items'] =
        this.shoppingList.map((item) => item.toMapOffline()).toList();
    map['is_deleted_offline'] = this.isDeletedOffline;

    return map;
  }
}
