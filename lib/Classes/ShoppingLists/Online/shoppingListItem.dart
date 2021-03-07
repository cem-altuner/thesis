import 'dart:ffi';

import '../../company.dart';

class ShoppingListItem {
  final int id;
  final int shoppingListId;
  final String product;
  final Company company;
  final bool isVisible;
  final String created_at;
  final String updated_at;
  bool isChecked;

  ShoppingListItem(
      {this.id,
      this.product,
      this.isVisible = true,
      this.created_at = "",
      this.updated_at = "",
      this.isChecked = false,
      this.company,
      this.shoppingListId});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
        shoppingListId: json['shopping_list'],
        id: json['id'],
        product: json['text'],
        company: Company(
            id: json['company_id'],
            name: json['company_name'],
            city: json['company_city'],
            country: json['company_country']),
        isVisible: json['is_visible'],
        isChecked: json['is_checked']);
  }

  Map toMapUpdate() {
    var map = new Map<String, dynamic>();
    map['shopping_list'] = this.shoppingListId;
    map["is_visible"] = this.isVisible;
    map['is_checked'] = this.isChecked;
    return map;
  }

  Map toMapAdd() {
    var map = new Map<String, dynamic>();
    map['shopping_list'] = this.shoppingListId;
    map["text"] = this.product;
    map["is_visible"] = this.isVisible;

    return map;
  }

  Map toMapOffline() {
    var map = new Map<String, dynamic>();
    map['shopping_list'] =
        this.shoppingListId != null ? this.shoppingListId : null;
    map['id'] = this.id != null ? this.id : null;
    map["text"] = this.product;
    map["is_visible"] = this.isVisible;
    map['is_checked'] = this.isChecked;

    return map;
  }
}
