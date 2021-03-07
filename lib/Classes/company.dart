import 'package:flutter/cupertino.dart';

class Company {
  final int id;
  final String name;
  final String country;
  final String city;
  final String logo;

  Company(
      {this.id = 0, this.name, this.country = "", this.city = "", this.logo});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        id: json['id'],
        name: json['name'],
        country: json['country'],
        city: json['city'],
        logo: json['logo']);
  }
}
