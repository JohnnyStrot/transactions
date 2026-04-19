import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository.dart';
import 'package:transactions/ui/details/details_viewmodel.dart';

class TransactionPartnerDetailsViewmodel
    extends
        DetailsViewmodel<
          TransactionPartner,
          TransactionPartnerDetailsViewmodel
        > {
  TransactionPartnerDetailsViewmodel({
    required TransactionPartnerRepository transactionPartnerRepository,
  }) : super(repository: transactionPartnerRepository);

  @override
  String get typeName => "Transaktions-Partny";
}
