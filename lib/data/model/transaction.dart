import 'package:transactions/data/model/entity.dart';
import 'package:transactions/data/model/to_many.dart';
import 'package:transactions/data/model/to_one.dart';
import 'package:transactions/data/model/transaction_part.dart';
import 'package:transactions/data/model/transaction_partner.dart';

class Transaction extends StrongEntity {
  Transaction({
    required this.id,
    this.remark = "",
    required this.timestamp,
    required ToOne<TransactionPartner> transactionPartner,
    required ToMany<TransactionPart> transactionParts,
  }) : _transactionPartner = transactionPartner,
       _transactionParts = transactionParts;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    remark: (json["remark"] ?? "") as String,
    timestamp: DateTime.parse(json["timestamp"]),
    transactionParts: ToMany.fromJson(
      json["transactionParts"],
      TransactionPart.fromJson,
    ),
    transactionPartner: ToOne.fromJson(
      json,
      TransactionPartner.fromJson,
      "transactionPartner",
    ),
  );

  @override
  int id;
  DateTime timestamp;
  String remark;

  ToOne<TransactionPartner> _transactionPartner;
  TransactionPartner? get transactionPartner => _transactionPartner.entity;
  set transactionPartner(TransactionPartner? tp) {
    _transactionPartner.entity = tp;
  }

  ToMany<TransactionPart> _transactionParts;
  List<TransactionPart> get transactionParts => _transactionParts.entities;

  @override
  Map<String, dynamic> toJson() {
    var a = <String, dynamic>{
      'id': id,
      'remark': remark,
      'timestamp': timestamp.toIso8601String(),
      'transactionParts': _transactionParts.toJson(),
    };
    a.addEntries([_transactionPartner.toJson("transactionPartner")]);
    return a;
  }

  factory Transaction.create(int id) => Transaction(
    id: id,
    timestamp: DateTime.now(),
    transactionPartner: ToOne(),
    transactionParts: ToMany(entities: []),
  );

  @override
  String get displayShort => "${timestamp.toIso8601String()} $value";

  double get value => transactionParts.fold(0, (sum, part) => sum + part.value);
}
