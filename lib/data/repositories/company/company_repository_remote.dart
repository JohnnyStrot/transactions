import 'package:transactions/data/model/company.dart';
import 'package:transactions/data/repositories/company/company_repository.dart';
import 'package:transactions/data/repositories/data_repository_remote.dart';

class CompanyRepositoryRemote extends DataRepositoryRemote<Company>
    implements CompanyRepository {
  CompanyRepositoryRemote({required super.apiService});

  @override
  Company Function(Map<String, dynamic> json) get fromJson => Company.fromJson;

  @override
  String get typeName => "Marke";

  @override
  String get typeApiEndpoint => "company";
}
