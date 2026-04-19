import 'package:transactions/data/model/company.dart';
import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/model/to_many.dart';
import 'package:transactions/data/model/to_one.dart';
import 'package:transactions/data/model/transaction_part.dart';

class Product extends StrongEntity {
  Product({
    required this.id,
    this.name = "",
    this.size,
    this.unit = "",
    this.package = "",
    this.imageLink = "",
    this.icon = "",
    this.link = "",
    this.deposit = 0,
    this.vegetarian,
    this.vegan,
    this.lactoseFree,
    this.glutenFree,
    this.favorite = false,
    required ToOne<Company> producer,
    required ToMany<TransactionPart> transactionParts,
    required ToOne<Product> parent,
    required ToMany<Product> children,
  }) : _producer = producer,
       _transactionParts = transactionParts,
       _parent = parent,
       _children = children;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: (json['name'] ?? "") as String,
    size: (json['size'] is int ? json["size"].toDouble() : json["size"]),
    unit: (json['unit'] ?? "") as String,
    package: (json['package'] ?? "") as String,
    imageLink: (json['image_link'] ?? "") as String,
    icon: (json['icon'] ?? "") as String,
    link: (json['link'] ?? "") as String,
    deposit: json["deposit"] is int
        ? json["deposit"].toDouble()
        : json['deposit'],
    vegetarian: json["vegetarian"],
    vegan: json["vegan"],
    lactoseFree: json["lactose_free"],
    glutenFree: json["gluten_free"],
    favorite: json["favorite"] ?? false,
    transactionParts: ToMany.fromJson(
      json["transaction_parts"],
      TransactionPart.fromJson,
    ),
    producer: ToOne.fromJson(json, Company.fromJson, "producer"),
    parent: ToOne.fromJson(json, Product.fromJson, "parent"),
    children: ToMany.fromJson(json["children"], Product.fromJson),
  );

  @override
  int id;
  String name;
  double? size;
  String unit;
  String package;
  String imageLink;
  String icon;
  String link;
  double? deposit;
  bool? vegetarian;
  bool? vegan;
  bool? lactoseFree;
  bool? glutenFree;
  bool favorite;

  ToOne<Company> _producer;
  Company? get producer => _producer.entity;
  set producer(Company? c) {
    _producer.entity = c;
  }

  ToMany<TransactionPart> _transactionParts;
  List<TransactionPart> get transactionParts => _transactionParts.entities;

  ToOne<Product> _parent;
  Product? get parent => _parent.entity;
  set parent(Product? p) {
    _parent.entity = p;
  }

  ToMany<Product> _children;
  List<Product?> get children => _children.entities;

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'id': id,
      'name': name,
      'size': size,
      'unit': unit,
      'package': package,
      'image_link': imageLink,
      'icon': icon,
      'link': link,
      'deposit': deposit?.toStringAsPrecision(2),
      'favorite': favorite,
      'vegetarian': vegetarian,
      'vegan': vegan,
      'lactose_free': lactoseFree,
      'gluten_free': glutenFree,
      'transaction_parts': _transactionParts.toJson(),
      'children': _children.toJson(),
    };
    a.addEntries([_producer.toJson("producer"), _parent.toJson("parent")]);
    return a;
  }

  factory Product.create(int id) => Product(
    id: id,
    children: ToMany(entities: []),
    parent: ToOne(),
    producer: ToOne(),
    transactionParts: ToMany(entities: []),
  );

  @override
  String get displayShort =>
      "${producer != null ? "${producer!.name} " : ""}$name";
}
