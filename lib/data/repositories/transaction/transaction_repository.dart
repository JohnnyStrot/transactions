import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/data/model/transaction_part.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/utils/result.dart';

abstract class TransactionRepository extends DataRepository<Transaction> {
  Future<Result<TransactionPart>> createPart();
}
