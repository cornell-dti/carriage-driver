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

  ///The url of the driver's profile picture.
  final String photoUrl;
  String fullName() => firstName + " " + lastName;

  Driver(
      {this.firstName,
        this.lastName,
        this.availability,
        this.vehicle,
        this.phoneNumber,
        this.email,
        this.photoUrl});

  ///Creates driver info from JSON representation.
  factory Driver.fromJson(Map<String, dynamic> json, String photoUrl) {
    return Driver(
        firstName: json['firstName'],
        lastName: json['lastName'],
        availability: json['availability'],
        vehicle: json['vehicle']['name'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        photoUrl: photoUrl);
  }
}
