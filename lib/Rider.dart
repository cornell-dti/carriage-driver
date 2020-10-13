import 'package:carriage/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Rider {
  String id;
  String email;
  String phoneNumber;
  String firstName;
  String lastName;
  List<String> accessibilityNeeds;

  Rider(this.id, this.email, this.phoneNumber, this.firstName, this.lastName, this.accessibilityNeeds);

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(json['id'], json['email'], json['phoneNumber'], json['firstName'], json['lastName'], List.from(json['accessibility']));
  }

  /*String accessibilityString() {
    Map<String, String> needs = {
      'needsWheelchair': 'Wheelchair',
      'hasCrutches': 'Crutches',
      'needsAssistant': 'Assistant'
    };
    String str = '';
    needs.forEach((need, name) {
      if (accessibilityNeeds[need]) {
        str += name;
        str += ', ';
      }
    });
    if (str.isEmpty) {
      str = 'None';
    }
    else {
      // remove trailing comma
      str = str.substring(0, str.length - 2);
    }
    return str;
  }*/

  static Future<Rider> retrieveRider(BuildContext context, String id) async {
    final response = await http.get(AppConfig.of(context).baseUrl + '/riders/$id');
    if (response.statusCode == 200) {
      return Rider.fromJson(json.decode(response.body));
    }
    else {
      throw Exception('failed to retrieve rider $id');
    }
  }
}