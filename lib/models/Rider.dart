import 'package:carriage/utils/CarriageTheme.dart';
import 'package:flutter/material.dart';

///Model for a rider. Matches the schema in the backend.
class Rider {
  ///The rider's id in the backend.
  final String id;

  ///The rider's email.
  final String email;

  ///The rider's phone number in format ##########.
  final String phoneNumber;

  ///The rider's first name.
  final String firstName;

  ///The rider's last name.
  final String lastName;

  ///The rider's accessibility needs.
  ///Can include 'Assistant', 'Crutches', 'Wheelchair'
  final List<String> accessibilityNeeds;

  ///The URL of the rider's profile picture.
  final String photoLink;

  Rider({
    this.id,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.accessibilityNeeds,
    this.photoLink
  });

  ///Creates a rider from JSON representation.
  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
        id: json['id'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        accessibilityNeeds: List.from(json['accessibility']),
        photoLink: 'http://' + json['photoLink']
    );
  }

  Widget profilePicture(double diameter) {
    return Container(
      height: diameter,
      width: diameter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: FadeInImage(
          fit: BoxFit.cover,
          placeholder: AssetImage(
            'assets/images/white.jpg',
          ),
          image: NetworkImage(this.photoLink),
        ),
      ),
    );
  }
}
