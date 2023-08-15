import 'package:dio/dio.dart';
import 'package:test_robinhood/model/category_model/category_model.dart';
import 'package:test_robinhood/services/base.repository.dart';

class CategoryRepository extends BaseRepository {
  Future<CategoryModel?> getCategories({required Map<String, dynamic> item}) async {
    try {
      final res = await dio.get(todoList, queryParameters: item);
      return CategoryModel.fromJson(res.data);
    } on DioException catch (e) {
      return null;
    }
  }
}
