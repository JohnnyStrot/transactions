import 'package:transactions/data/model/company.dart';
import 'package:transactions/data/repositories/company/company_repository.dart';
import 'package:transactions/ui/details/details_viewmodel.dart';

class CompanyDetailsViewmodel
    extends DetailsViewmodel<Company, CompanyDetailsViewmodel> {
  CompanyDetailsViewmodel({required CompanyRepository companyRepository})
    : super(repository: companyRepository);

  @override
  String get typeName => "Marke";
}
