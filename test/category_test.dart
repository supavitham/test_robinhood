import 'package:flutter_test/flutter_test.dart';
import 'package:test_robinhood/repository/category_repo/category_repo.dart';
import 'package:collection/collection.dart';

void main() {
  late CategoryRepository categoryRepository;

  setUp(() {
    categoryRepository = CategoryRepository();
  });

  group('Call category todo list', () {
    test('status todo', () async {
      Map<String, dynamic> dataSend = {
        'offset': 0,
        'limit': 10,
        'sortBy': 'createdAt',
        'isAsc': true,
        'status': 'TODO',
      };
      var res = (await categoryRepository.getCategories(item: dataSend))?.tasks?.firstWhereOrNull((element) => element.status == 'TODO')?.status;
      expect(res, 'TODO');
    });

    test('status doing', () async {
      Map<String, dynamic> dataSend = {
        'offset': 0,
        'limit': 10,
        'sortBy': 'createdAt',
        'isAsc': true,
        'status': 'DOING',
      };
      var res = (await categoryRepository.getCategories(item: dataSend))?.tasks?.firstWhereOrNull((element) => element.status == 'DOING')?.status;
      expect(res, 'DOING');
    });

    test('status done', () async {
      Map<String, dynamic> dataSend = {
        'offset': 0,
        'limit': 10,
        'sortBy': 'createdAt',
        'isAsc': true,
        'status': 'DONE',
      };
      var res = (await categoryRepository.getCategories(item: dataSend))?.tasks?.firstWhereOrNull((element) => element.status == 'DONE')?.status;
      expect(res, 'DONE');
    });
  });
}
