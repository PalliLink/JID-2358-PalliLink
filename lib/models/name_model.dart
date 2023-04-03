class Name {
  late String family;
  late String given;
  String prefix = "";
  String suffix = "";
  late String text;

  Name(this.family, this.given, this.text);

  Name.fromJson(Map<dynamic, dynamic> json) {
    family = json['family'];
    given = json['given'];
    text = json['text'];
  }
}
