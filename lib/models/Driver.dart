import 'package:intl/intl.dart';

///Model for a driver's info. Matches the schema in the backend.
class Driver {
  ///The first name of the driver.
  final String firstName;

  ///The last name of the driver.
  final String lastName;

  ///The rider's phone number in format ##########.
  final String phoneNumber;

  ///The driver's email.
  final String email;

  ///The URL of the driver's profile picture.
  final String photoLink;

  ///The date that the driver joined, formatted as mm/dd/yyyy from backend
  final String startDate;

  Driver({this.firstName, this.lastName, this.startDate, this.phoneNumber, this.email, this.photoLink});

  ///Creates driver info from JSON representation. The query at the end of photoLink is to
  // force the network images that display it to re-fetch the photo, because it won't
  // if the URL is the same, and the URL does not change after an upload to backend.
  factory Driver.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return Driver(
        firstName: data['firstName'],
        lastName: data['lastName'],
        startDate: DateFormat('MM/yyyy').format((DateFormat('yyyy-MM-dd').parse(data['startDate']))),
        phoneNumber: data['phoneNumber'],
        email: data['email'],
        photoLink:
            data['photoLink'] == null ? null : data['photoLink'] + '?dummy=${DateTime.now().millisecondsSinceEpoch}');
  }

  Driver copyWithPhoto(String newPhoto) {
    return Driver(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email,
        photoLink: 'http://' + newPhoto);
  }
}
