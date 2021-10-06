class RegToInstructorData {
  String instructorName;
  String phoneNumber;
  DateTime date;
  String time;

  RegToInstructorData(
      this.instructorName, this.phoneNumber, this.date, this.time);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegToInstructorData &&
          runtimeType == other.runtimeType &&
          instructorName == other.instructorName &&
          phoneNumber == other.phoneNumber &&
          date == other.date &&
          time == other.time;

  @override
  int get hashCode =>
      instructorName.hashCode ^
      phoneNumber.hashCode ^
      date.hashCode ^
      time.hashCode;
}
