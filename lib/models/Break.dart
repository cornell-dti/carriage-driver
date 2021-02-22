///Type for a break in a driver's schedule.
class Break {
  ///Full name of the day of the week the break occurs again.
  String day;

  ///The start time of the break.
  String startTime;

  ///The end time of the break.
  String endTime;
  Break(this.day, this.startTime, this.endTime);

  ///Creates a break from JSON representation.
  factory Break.fromJson(String day, Map<String, dynamic> json) {
    return Break(day, json['breakStart'], json['breakEnd']);
  }

  String toString() {
    return "$day: $startTime to $endTime";
  }
}

///Collection of times when the driver goes on break.
class Breaks {
  List<Break> breaks;
  Breaks(this.breaks);

  ///Creates breaks from JSON representation.
  factory Breaks.fromJson(Map<String, dynamic> json) {
    List<Break> breaks = [];
    json.forEach((k, v) {
      breaks.add(Break.fromJson((abbrevToDay(k)), json[k]));
    });
    return Breaks(breaks);
  }

  ///Converts a 3-character abbreviation for a day of the week [abbrev]
  ///to its full name.
  static String abbrevToDay(String abbrev) {
    switch (abbrev) {
      case ("Mon"):
        return "Monday";
      case ("Tue"):
        return "Tuesday";
      case ("Wed"):
        return "Wednesday";
      case ("Thu"):
        return "Thursday";
      case ("Fri"):
        return "Friday";
      default:
        return "INVALID DAY";
    }
  }

  String toString() {
    if (breaks.isEmpty)
      return "None";
    else {
      String str = "";
      for (Break b in breaks) {
        str += b.toString();
        if (b != breaks.last) {
          str += "\n";
        }
      }
      return str;
    }
  }
}
