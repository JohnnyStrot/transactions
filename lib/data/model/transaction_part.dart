import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/model/to_one.dart';
import 'package:transactions/data/model/transaction.dart';

class TransactionPart extends StrongEntity {
  TransactionPart({
    required this.id,
    this.purpose = "",
    this.amount,
    required this.value,
    required ToOne<Transaction> transaction,
    required ToOne<Product> product,
  }) : _transaction = transaction,
       _product = product;

  factory TransactionPart.fromJson(Map<String, dynamic> json) {
    return TransactionPart(
      id: json['id'],
      purpose: (json["purpose"] ?? "") as String,
      value: json["value"] is int ? json["value"].toDouble() : json["value"],
      amount: json["amount"] is int
          ? json["amount"].toDouble()
          : json["amount"],
      transaction: ToOne.fromJson(json, Transaction.fromJson, "transaction"),
      product: ToOne.fromJson(json, Product.fromJson, "product"),
    );
  }

  @override
  int id;
  double value;
  double? amount;
  String purpose;

  ToOne<Transaction> _transaction;
  Transaction? get transaction => _transaction.entity;

  ToOne<Product> _product;
  Product? get product => _product.entity;
  set product(Product? p) {
    _product.entity = p;
  }

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'id': id,
      'purpose': purpose,
      'amount': amount,
      'value': value,
    };
    a.addEntries([
      _transaction.toJson("transaction"),
      _product.toJson("product"),
    ]);
    return a;
  }

  factory TransactionPart.create(int id) =>
      TransactionPart(id: id, product: ToOne(), transaction: ToOne(), value: 0);

  @override
  String get displayShort =>
      "${value.toStringAsFixed(2)}${amount != null ? " ${amount!.toStringAsPrecision(6)} * " : ""} ${product != null ? product!.displayShort : purpose}";
}
