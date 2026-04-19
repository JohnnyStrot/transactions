import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/repositories/product/product_repository.dart';
import 'package:transactions/ui/details/details_viewmodel.dart';

class ProductDetailsViewmodel
    extends DetailsViewmodel<Product, ProductDetailsViewmodel> {
  ProductDetailsViewmodel({required ProductRepository productRepository})
    : super(repository: productRepository);

  @override
  String get typeName => "Produkt";
}
