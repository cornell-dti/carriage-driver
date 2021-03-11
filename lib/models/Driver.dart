import 'package:carriage/providers/AuthProvider.dart';

///Model for a driver's info. Matches the schema in the backend.
class Driver {
  ///The first name of the driver.
  final String firstName;

  ///The last name of the driver.
  final String lastName;

  ///Time that the driver works.
  final Map<String, dynamic> availability;

  ///Name of the vehicle the driver uses.
  final String vehicle;

  ///The rider's phone number in format ##########.
  final String phoneNumber;

  ///The driver's email.
  final String email;

  ///The URL of the driver's profile picture.
  final String photoLink;

  Driver({
    this.firstName,
    this.lastName,
    this.availability,
    this.vehicle,
    this.phoneNumber,
    this.email,
    this.photoLink
  });

  ///Creates driver info from JSON representation.
  factory Driver.fromJson(AuthProvider authProvider, Map<String, dynamic> json) {
    return Driver(
        firstName: json['firstName'],
        lastName: json['lastName'],
        availability: json['availability'],
        vehicle: json['vehicle']['name'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        photoLink: json['photoLink'] == null ? authProvider.googleSignIn.currentUser.photoUrl : 'http://' + json['photoLink']
    );
  }

  Driver copyWithPhoto(String newPhoto) {
    return Driver(
        firstName: this.firstName,
        lastName: this.lastName,
        availability: this.availability,
        vehicle: this.vehicle,
        phoneNumber: this.phoneNumber,
        email: this.email,
        photoLink: 'http://' + newPhoto
    );
  }
}
