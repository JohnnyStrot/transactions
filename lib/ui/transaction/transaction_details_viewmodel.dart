import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/data/model/transaction_part.dart';
import 'package:transactions/data/repositories/transaction/transaction_repository.dart';
import 'package:transactions/ui/details/details_viewmodel.dart';
import 'package:transactions/utils/result.dart';

class TransactionDetailsViewmodel
    extends DetailsViewmodel<Transaction, TransactionDetailsViewmodel> {
  TransactionDetailsViewmodel({required this.transactionRepository})
    : super(repository: transactionRepository);

  TransactionRepository transactionRepository;

  @override
  String get typeName => "Transaktion";

  Future<TransactionPart?> createPart() async {
    var res = await transactionRepository.createPart();
    switch (res) {
      case Ok<TransactionPart>():
        return res.value;
      case Error<TransactionPart>():
        return null;
    }
  }
}
