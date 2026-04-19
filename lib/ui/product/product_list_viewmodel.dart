import 'package:flutter_command/flutter_command.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/repositories/product/product_repository.dart';
import 'package:transactions/ui/list_widgets/data_list_viewmodel.dart';

class ProductListViewmodel extends DataListViewmodel<Product> {
  ProductListViewmodel({required ProductRepository productRepository})
    : super(repository: productRepository) {
    nameChanged = Command.createAsyncNoResult((s) async {
      _searchName = s;
      exLoadEntities();
    });
    producerChanged = Command.createAsyncNoResult((s) async {
      _searchProducer = s;
      exLoadEntities();
    });
  }

  late final Command<String?, void> nameChanged;
  late final Command<String?, void> producerChanged;

  String? _searchName;
  String? _searchProducer;

  @override
  searchValues() {
    var search = <String, dynamic>{};
    if (_searchName != null) {
      search["name"] = _searchName;
    }
    if (_searchProducer != null) {
      search["producer"] = _searchProducer;
    }
    return search;
  }
}
