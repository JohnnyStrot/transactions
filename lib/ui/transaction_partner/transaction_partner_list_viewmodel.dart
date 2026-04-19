import 'package:flutter_command/flutter_command.dart';
import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository.dart';
import 'package:transactions/ui/list_widgets/data_list_viewmodel.dart';

class TransactionPartnerListViewmodel
    extends DataListViewmodel<TransactionPartner> {
  TransactionPartnerListViewmodel({
    required TransactionPartnerRepository transactionPartnerRepository,
  }) : super(repository: transactionPartnerRepository) {
    nameChanged = Command.createAsyncNoResult((s) async {
      _searchName = s;
      exLoadEntities();
    });
    companyChanged = Command.createAsyncNoResult((s) async {
      _searchCompany = s;
      exLoadEntities();
    });
    cityChanged = Command.createAsyncNoResult((s) async {
      _searchCity = s;
      exLoadEntities();
    });
  }

  late final Command<String?, void> nameChanged;
  late final Command<String?, void> companyChanged;
  late final Command<String?, void> cityChanged;

  String? _searchName;
  String? _searchCompany;
  String? _searchCity;

  @override
  searchValues() {
    var search = <String, dynamic>{};
    if (_searchName != null) {
      search["name"] = _searchName;
    }
    if (_searchCity != null) {
      search["city"] = _searchCity;
    }
    if (_searchCompany != null) {
      search["company"] = _searchCompany;
    }
    return search;
  }
}
