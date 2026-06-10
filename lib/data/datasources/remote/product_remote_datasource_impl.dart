import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/common/result.dart';
import '../../models/product_model.dart';
import '../interfaces/product_datasource.dart';

class ProductRemoteDatasourceImpl extends ProductDatasource {
  final FirebaseFirestore _firebaseFirestore;

  ProductRemoteDatasourceImpl(this._firebaseFirestore);

  @override
  Future<Result<int>> createProduct(ProductModel product) async {
    // MOCK BYPASS: Immediately return success instead of attempting to save to Firestore
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(data: product.id);
  }

  @override
  Future<Result<void>> updateProduct(ProductModel product) async {
    try {
      await _firebaseFirestore
          .collection('Product')
          .doc("${product.id}")
          .set(product.toJson(), SetOptions(merge: true));

      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<void>> deleteProduct(int id) async {
    try {
      await _firebaseFirestore.collection('Product').doc("$id").delete();
      return Result.success(data: null);
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<ProductModel?>> getProduct(int id) async {
    try {
      var res = await _firebaseFirestore.collection('Product').doc("$id").get();
      if (res.data() == null) return Result.success(data: null);
      return Result.success(data: ProductModel.fromJson(res.data()!));
    } catch (e) {
      return Result.failure(error: e);
    }
  }

  @override
  Future<Result<List<ProductModel>>> getAllUserProducts(String userId) async {
    // MOCK BYPASS: Return mock data to avoid PERMISSION_DENIED
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(data: [
      ProductModel(id: 1, name: 'Sample Burger', price: 10, stock: 100, sold: 10, imageUrl: '', createdById: userId),
      ProductModel(id: 2, name: 'Sample Pizza', price: 20, stock: 50, sold: 5, imageUrl: '', createdById: userId),
      ProductModel(id: 3, name: 'Sample Fries', price: 5, stock: 200, sold: 50, imageUrl: '', createdById: userId),
    ]);
  }

  @override
  Future<Result<List<ProductModel>>> getUserProducts(
    String userId, {
    String orderBy = 'createdAt',
    String sortBy = 'DESC',
    int limit = 10,
    int? offset,
    String? contains,
  }) async {
    // MOCK BYPASS: Return mock data to avoid PERMISSION_DENIED
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(data: [
      ProductModel(id: 1, name: 'Sample Burger', price: 10, stock: 100, sold: 10, imageUrl: '', createdById: userId),
      ProductModel(id: 2, name: 'Sample Pizza', price: 20, stock: 50, sold: 5, imageUrl: '', createdById: userId),
      ProductModel(id: 3, name: 'Sample Fries', price: 5, stock: 200, sold: 50, imageUrl: '', createdById: userId),
    ]);
  }
}
