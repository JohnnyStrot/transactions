import 'dart:convert';

import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/repositories/product/product_repository.dart';
import 'package:transactions/data/repositories/data_repository_remote.dart';
import 'package:transactions/utils/result.dart';

class ProductRepositoryRemote extends DataRepositoryRemote<Product>
    implements ProductRepository {
  ProductRepositoryRemote({required super.apiService});

  @override
  Product Function(Map<String, dynamic> json) get fromJson => Product.fromJson;

  @override
  String get typeName => "Produkt";

  @override
  String get typeApiEndpoint => "product";

  @override
  Future<Result<List<Product>>> getChildren(int parentId) async {
    return await apiService
        .get("$typeApiEndpoint/children/$parentId")
        .then((response) {
          return Result<List<Product>>.ok(
            (jsonDecode(response.body) as List<dynamic>)
                .map((c) => Product.fromJson(c))
                .toList(),
          );
        })
        .catchError((err) {
          return Result<List<Product>>.error(Exception(err));
        });
  }
}
