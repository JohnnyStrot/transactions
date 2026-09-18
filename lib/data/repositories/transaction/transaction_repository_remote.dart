import 'dart:convert';

import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/data/model/transaction_part.dart';
import 'package:transactions/data/repositories/data_repository_remote.dart';
import 'package:transactions/data/repositories/transaction/transaction_repository.dart';
import 'package:transactions/utils/result.dart';

class TransactionRepositoryRemote extends DataRepositoryRemote<Transaction>
    implements TransactionRepository {
  TransactionRepositoryRemote({required super.apiService});

  @override
  Transaction Function(Map<String, dynamic> json) get fromJson =>
      Transaction.fromJson;

  @override
  String get typeName => "Transaktion";

  @override
  String get typeApiEndpoint => "transaction";

  @override
  Future<Result<TransactionPart>> createPart() async {
    return await apiService
        .get("$typeApiEndpoint/create-part")
        .then((response) {
          print(response.body);
          return Result<TransactionPart>.ok(
            TransactionPart.fromJson(jsonDecode(response.body)),
          );
        })
        .catchError((err) {
          return Result<TransactionPart>.error(Exception(err));
        });
  }

  @override
  Future<Result<Transaction>> saveTransaction(
    Transaction entity, {
    List<TransactionPartContent>? content,
  }) async {
    var json = entity.toJson();
    json["transactionParts"] = content?.map((c) => c.toJson()).toList();
    return await apiService
        .put("$typeApiEndpoint/${entity.id}", json)
        .then((response) {
          return Result<Transaction>.ok(
            Transaction.fromJson(jsonDecode(response.body)),
          );
        })
        .catchError((err) {
          return Result<Transaction>.error(Exception(err));
        });
  }
}
