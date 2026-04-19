import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/data_repository_remote.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository.dart';

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
}
