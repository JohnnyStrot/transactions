import 'package:flutter_command/flutter_command.dart';
import 'package:transactions/data/model/company.dart';
import 'package:transactions/data/repositories/company/company_repository.dart';
import 'package:transactions/ui/list_widgets/data_list_viewmodel.dart';

class CompanyListViewmodel extends DataListViewmodel<Company> {
  CompanyListViewmodel({required CompanyRepository companyRepository})
    : super(repository: companyRepository) {
    nameChanged = Command.createAsyncNoResult((s) async {
      _searchName = s;
      exLoadEntities();
    });
  }

  late final Command<String?, void> nameChanged;

  String? _searchName;

  @override
  searchValues() {
    var search = <String, dynamic>{};
    if (_searchName != null) {
      search["name"] = _searchName;
    }
    return search;
  }
}
