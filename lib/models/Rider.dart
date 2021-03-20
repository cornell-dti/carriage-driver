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
        accessibilityNeeds: json['accessibility'] == null ? [] : List.from(json['accessibility']),
        photoLink: json['photoLink'] == null ? null : 'http://' + json['photoLink']
    );
  }

  Widget profilePicture(double diameter) {
    return Container(
      height: diameter,
      width: diameter,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: photoLink == null ? Image.asset(
              'assets/images/person.png',
              width: diameter,
              height: diameter
          ) : Image.network(
            this.photoLink,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
      ),
    );
  }
}
