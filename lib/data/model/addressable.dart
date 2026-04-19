abstract class Addressable {
  String get postcode;
  String get city;
  String get street;
  String get houseNumber;

  String get address;

  set postcode(String s);
  set city(String s);
  set street(String s);
  set houseNumber(String s);
}
