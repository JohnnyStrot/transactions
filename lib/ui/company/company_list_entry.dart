import 'package:transactions/data/model/company.dart';
import 'package:transactions/routing/routes.dart';
import 'package:transactions/ui/entity/entity_list_entry.dart';

class CompanyListEntry extends EntityListEntry<Company> {
  const CompanyListEntry({
    super.key,
    required super.entity,
    required super.onDelete,
  });

  @override
  String route(op) => Routes.companies;

  @override
  String entityToString(Company opp) => opp.displayShort;
}
