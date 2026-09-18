import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/utils/result.dart';

abstract class ProductRepository extends DataRepository<Product> {
  Future<Result<List<Product>>> getChildren(int parentId);
  Future<Result<List<(Product, double?)>>> searchWithPrice(
    int page,
    TransactionPartner? partner,
    String? product,
    String? producer,
  );
}
