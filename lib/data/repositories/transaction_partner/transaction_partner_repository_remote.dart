import 'dart:convert';

import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/data_repository_remote.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository.dart';
import 'package:transactions/utils/result.dart';

class TransactionPartnerRepositoryRemote
    extends DataRepositoryRemote<TransactionPartner>
    implements TransactionPartnerRepository {
  TransactionPartnerRepositoryRemote({required super.apiService});

  @override
  TransactionPartner Function(Map<String, dynamic> json) get fromJson =>
      TransactionPartner.fromJson;

  @override
  String get typeName => "Transaktions-Partny";

  @override
  String get typeApiEndpoint => "transaction-partner";

  @override
  Future<Result<List<TransactionPartner>>> searchPartner(
    int page,
    String? search,
    String? city,
  ) async {
    final pageSize = 20;
    return await apiService
        .get(
          "$typeApiEndpoint/search-partner",
          params: {
            "skip": (page - 1) * pageSize,
            "take": pageSize,
            "search": ?search,
            "city": ?city,
          },
        )
        .then((response) {
          var res = jsonDecode(response.body);

          return Result<List<TransactionPartner>>.ok(
            (res as List<dynamic>)
                .map<TransactionPartner>((c) => TransactionPartner.fromJson(c))
                .toList(),
          );
        })
        .catchError((err) {
          return Result<List<TransactionPartner>>.error(Exception(err));
        });
  }
}
