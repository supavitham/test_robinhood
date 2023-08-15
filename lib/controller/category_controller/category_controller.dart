import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:test_robinhood/model/category_model/category_model.dart';
import 'package:test_robinhood/repository/category_repo/category_repo.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryController extends ChangeNotifier {
  final BuildContext context;

  CategoryController(this.context);

  final categoryRepository = CategoryRepository();
  CategoryModel? _categoryData;
  int _currentTab = 0;
  int limit = 10;
  List<DateTime> dateTimeGroup = [];
  List<ShowDataCategoryWidget> _showDataCategoryWidget = [];
  Timer? _sessionTimer;
  int _start = 10;

  Future<void> getCategories({bool isLoadMore = false}) async {
    try {
      Map<String, dynamic> dataSend = {
        'offset': categoryData?.pageNumber ?? 0,
        'limit': limit,
        'sortBy': 'createdAt',
        'isAsc': true,
        'status': currentTab == 0
            ? 'TODO'
            : currentTab == 1
                ? 'DOING'
                : 'DONE',
      };
      EasyLoading.show();
      var res = await categoryRepository.getCategories(item: dataSend);
      if (!isLoadMore) {
        categoryData = res;
      } else if (res != null) {
        categoryData?.tasks?.addAll(res.tasks!);
        categoryData?.pageNumber = res.pageNumber!;
      }

      if (categoryData != null && categoryData!.tasks!.isNotEmpty) {
        await mapDataTask();
      }
      EasyLoading.dismiss();
    } on Exception catch (e) {
      EasyLoading.dismiss();
    }
  }

  checkLoadMore() {
    if (categoryData!.pageNumber! < (categoryData!.totalPages! - 1)) {
      categoryData!.pageNumber = categoryData!.pageNumber! + 1;
      getCategories(isLoadMore: true);
    }
  }

  mapDataTask() async {
    showDataCategoryWidget = [];
    dateTimeGroup = [];
    try {
      categoryData!.tasks!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      categoryData!.tasks!.map((e) {
        String date = DateFormat("dd MMM yyyy").format(e.createdAt!);
        dateTimeGroup.add(DateFormat('dd MMM yyyy').parse(date));
      }).toList();
      dateTimeGroup = dateTimeGroup.toSet().toList();
      dateTimeGroup.map((e) {
        ShowDataCategoryWidget newData = ShowDataCategoryWidget();
        newData.createdAt = e;
        var res = categoryData!.tasks!.where((itemTask) {
          String date = DateFormat("dd MMM yyyy").format(itemTask.createdAt!);
          var dateFormat = DateFormat('dd MMM yyyy').parse(date);
          return e.compareTo(dateFormat) == 0 ? true : false;
        }).toList();
        newData.item = res;
        showDataCategoryWidget.add(newData);
        notifyListeners();
      }).toList();
    } on Exception catch (e) {}
  }

  void startTimer({required Function callLockScreen}) {
    const oneSec = Duration(seconds: 1);
    _sessionTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          clearTimer();
          callLockScreen.call();
        } else {
          _start--;
        }
      },
    );
  }

  clearTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _start = 10;
  }

  CategoryModel? get categoryData => _categoryData;

  set categoryData(CategoryModel? value) {
    _categoryData = value;
    notifyListeners();
  }

  int get currentTab => _currentTab;

  set currentTab(int value) {
    _currentTab = value;
    notifyListeners();
  }

  List<ShowDataCategoryWidget> get showDataCategoryWidget => _showDataCategoryWidget;

  set showDataCategoryWidget(List<ShowDataCategoryWidget> value) {
    _showDataCategoryWidget = value;
    notifyListeners();
  }
}

class ShowDataCategoryWidget {
  DateTime? createdAt;
  List<TaskModel>? item;

  ShowDataCategoryWidget({
    this.createdAt,
    this.item,
  });

  @override
  String toString() {
    return 'ShowDataCategoryWidget{createdAt: $createdAt, item: $item}';
  }
}
