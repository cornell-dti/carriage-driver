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

  Rider(
      {this.id,
      this.email,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.accessibilityNeeds});

  ///Creates a rider from JSON representation.
  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
        id: json['id'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        accessibilityNeeds: List.from(json['accessibility']));
  }
}
