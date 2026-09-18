import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/utils/result.dart';

abstract class TransactionPartnerRepository
    extends DataRepository<TransactionPartner> {
  Future<Result<List<TransactionPartner>>> searchPartner(
    int page,
    String? search,
    String? city,
  );
}
