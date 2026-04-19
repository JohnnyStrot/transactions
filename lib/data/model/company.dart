import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/model/to_many.dart';
import 'package:transactions/data/model/transaction_partner.dart';

class Company extends StrongEntity {
  Company({
    required this.id,
    this.name = "",
    required ToMany<Product> products,
    required ToMany<TransactionPartner> subsidiaries,
  }) : _products = products,
       _subsidiaries = subsidiaries;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json['id'],
    name: (json['name'] ?? "") as String,
    products: ToMany.fromJson(json["products"], Product.fromJson),
    subsidiaries: ToMany.fromJson(
      json["subsidiaries"],
      TransactionPartner.fromJson,
    ),
  );

  @override
  int id;
  String name;

  ToMany<Product> _products;
  List<Product> get products => _products.entities;

  ToMany<TransactionPartner> _subsidiaries;
  List<TransactionPartner> get subsidiaries => _subsidiaries.entities;

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'id': id,
      'name': name,
      'products': _products.toJson(),
      'subsidiaries': _subsidiaries.toJson(),
    };
    return a;
  }

  factory Company.create(int id) => Company(
    id: id,
    products: ToMany(entities: []),
    subsidiaries: ToMany(entities: []),
  );

  @override
  String get displayShort => name;
}
