import 'package:carriage/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///Model for a rider. Matches the schema in the backend.
class Rider {
  ///The rider's id in the backend.
  String id;

  ///The rider's email.
  String email;

  ///The rider's phone number in format #########.
  String phoneNumber;

  ///The rider's first name.
  String firstName;

  ///The rider's last name.
  String lastName;

  ///The rider's accessibility needs.
  ///Can include 'Assistant', 'Crutches', 'Wheelchair'
  List<String> accessibilityNeeds;

  Rider(this.id, this.email, this.phoneNumber, this.firstName, this.lastName,
      this.accessibilityNeeds);

  ///Creates a rider from JSON representation.
  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(json['id'], json['email'], json['phoneNumber'],
        json['firstName'], json['lastName'], List.from(json['accessibility']));
  }

  ///Retrieves the rider with id [id] from the backend.
  static Future<Rider> retrieveRider(BuildContext context, String id) async {
    final response =
        await http.get(AppConfig.of(context).baseUrl + '/riders/$id');
    if (response.statusCode == 200) {
      return Rider.fromJson(json.decode(response.body));
    } else {
      throw Exception('failed to retrieve rider $id');
    }
  }
}
