import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/repositories/data_repository.dart';
import 'package:transactions/utils/result.dart';

abstract class ProductRepository extends DataRepository<Product> {
  Future<Result<List<Product>>> getChildren(int parentId);
}
