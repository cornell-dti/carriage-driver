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

  Driver({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.photoLink
  });

  ///Creates driver info from JSON representation. The query at the end of photoLink is to
  // force the network images that display it to re-fetch the photo, because it won't
  // if the URL is the same, and the URL does not change after an upload to backend.
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        firstName: json['firstName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        photoLink: json['photoLink'] == null ? null : 'https://' + json['photoLink'] + '?dummy=${DateTime.now().millisecondsSinceEpoch}'
    );
  }

  Driver copyWithPhoto(String newPhoto) {
    return Driver(
        firstName: this.firstName,
        lastName: this.lastName,
        phoneNumber: this.phoneNumber,
        email: this.email,
        photoLink: 'http://' + newPhoto
    );
  }
}
