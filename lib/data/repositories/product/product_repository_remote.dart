import 'dart:convert';

import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/model/transaction_partner.dart';
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

  @override
  Future<Result<List<(Product, double?)>>> searchWithPrice(
    int page,
    TransactionPartner? partner,
    String? product,
    String? producer,
  ) async {
    final pageSize = 20;
    return await apiService
        .get(
          "$typeApiEndpoint/search-with-price",
          params: {
            "skip": (page - 1) * pageSize,
            "take": pageSize,
            "name": ?product,
            "partner": ?(partner?.id),
            "company": ?(partner?.company?.id),
            "producer": ?producer,
          },
        )
        .then((response) {
          var res = jsonDecode(response.body);

          return Result<List<(Product, double?)>>.ok(
            (res as List<dynamic>)
                .map<(Product, double?)>(
                  (c) => (
                    Product.fromJson(c["product"]),
                    double.tryParse(c["sum"] ?? ""),
                  ),
                )
                .toList(),
          );
        })
        .catchError((err) {
          return Result<List<(Product, double?)>>.error(Exception(err));
        });
  }
}
