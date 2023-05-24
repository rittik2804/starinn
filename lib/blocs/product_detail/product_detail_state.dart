import 'package:listar_flutter_pro/models/model.dart';

abstract class ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailSuccess extends ProductDetailState {
  final ProductModel product;
  int currentBanner;

  ProductDetailSuccess(this.product, {required this.currentBanner});
}
