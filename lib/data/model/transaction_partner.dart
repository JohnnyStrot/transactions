import 'package:transactions/data/model/addressable.dart';
import 'package:transactions/data/model/company.dart';
import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/model/to_many.dart';
import 'package:transactions/data/model/to_one.dart';
import 'package:transactions/data/model/transaction.dart';

class TransactionPartner extends StrongEntity implements Addressable {
  TransactionPartner({
    required this.id,
    this.name = "",
    this.city = "",
    this.postcode = "",
    this.street = "",
    this.houseNumber = "",
    this.favorite = false,
    required ToOne<Company> company,
    required ToMany<Transaction> transactions,
  }) : _company = company,
       _transactions = transactions;

  factory TransactionPartner.fromJson(Map<String, dynamic> json) =>
      TransactionPartner(
        id: json['id'],
        name: (json['name'] ?? "") as String,
        postcode: (json['postcode'] ?? "") as String,
        city: (json['city'] ?? "") as String,
        street: (json['street'] ?? "") as String,
        houseNumber: (json['house_number'] ?? "") as String,
        favorite: json["favorite"] ?? false,
        transactions: ToMany.fromJson(
          json["transactions"],
          Transaction.fromJson,
        ),
        company: ToOne.fromJson(json, Company.fromJson, "company"),
      );

  @override
  int id;
  String name;
  @override
  String city;
  @override
  String postcode;
  @override
  String street;
  @override
  String houseNumber;
  bool favorite;

  ToOne<Company> _company;
  Company? get company => _company.entity;
  set company(Company? c) {
    _company.entity = c;
  }

  ToMany<Transaction> _transactions;
  List<Transaction> get transactions => _transactions.entities;

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'id': id,
      'name': name,
      'postcode': postcode,
      'city': city,
      'street': street,
      'house_number': houseNumber,
      'favorite': favorite,
      'transactions': _transactions.toJson(),
    };
    a.addEntries([_company.toJson("company")]);
    return a;
  }

  factory TransactionPartner.create(int id) => TransactionPartner(
    id: id,
    company: ToOne(),
    transactions: ToMany(entities: []),
  );

  @override
  String get displayShort =>
      "${company != null ? company!.name : name}${city.isNotEmpty ? ", $city" : ""}";

  String get title => company?.name ?? name;
  String get subtitle => company == null ? "" : name;

  @override
  String get address => [
    [
      if (street.isNotEmpty) street,
      if (houseNumber.isNotEmpty) houseNumber,
    ].join(" "),
    [if (postcode.isNotEmpty) postcode, if (city.isNotEmpty) city].join(" "),
  ].join(", ");

  String? get cityStreet =>
      city.isNotEmpty ? [if (street.isNotEmpty) street, city].join(", ") : null;
}
