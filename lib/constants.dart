enum ServiceType {
  officeVisit("Office Visit"),
  procedure("Procedure"),
  video("PalliLink Video Call");

  final String value;

  const ServiceType(this.value);
}

enum Gender {
  male("Male"),
  female("Female");

  final String value;

  const Gender(this.value);
}

enum NumberType {
  mobile("Mobile"),
  home("Home"),
  work("Work"),
  other("Other");

  final String value;

  const NumberType(this.value);
}

enum AuthStatus {
  unknownEmail(
      "The username/password combination does not match any existing entries."),
  incorrectPassword(
      "The username/password combination does not match any existing entries."),
  incorrectAccountType(
      "The username/password combination does not match any existing entries."),
  serverError("There was a server error. Please try again later."),
  unknownError("An unknown error has occured."),
  success("The operation was a success.");

  final String value;

  const AuthStatus(this.value);
}

enum UserType {
  patient("Patient"),
  practitioner("Practitioner"),
  administrator("Admin");

  final String value;

  const UserType(this.value);
}
