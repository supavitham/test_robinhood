import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_robinhood/controller/category_controller/category_controller.dart';
import 'package:test_robinhood/model/enum.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  late CategoryController categoryController;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    categoryController = Provider.of<CategoryController>(context, listen: false);
    categoryController.startTimer(callLockScreen: () => showLockScreen());
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _tabController?.addListener(() async {
        if (_tabController?.indexIsChanging == true) {
          categoryController.currentTab = _tabController!.index;
          categoryController.categoryData = null;
          categoryController.getCategories();
        }
      });
      categoryController.getCategories();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      categoryController.clearTimer();
      categoryController.startTimer(
        callLockScreen: () => showLockScreen(),
      );
    } else {
      categoryController.clearTimer();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        categoryController.clearTimer();
      },
      onPointerUp: (event) {
        categoryController.startTimer(callLockScreen: () => showLockScreen());
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.passthrough,
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Expanded(
                  child: Consumer<CategoryController>(
                    builder: (BuildContext context, p, Widget? child) {
                      return TabBarView(
                        controller: _tabController,
                        children: CategoryStatus.values
                            .map((e) => LazyLoadScrollView(
                                  onEndOfPage: () {
                                    p.checkLoadMore();
                                  },
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.15,
                                        ),
                                        ...p.showDataCategoryWidget
                                            .map(
                                              (e) => Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                                margin: EdgeInsets.only(bottom: 8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text(
                                                      DateFormat("dd MMM yyyy").format(e.createdAt!),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 16),
                                                    ...e.item!
                                                        .map(
                                                          (itemTask) => Container(
                                                            margin: EdgeInsets.only(bottom: 16),
                                                            child: Dismissible(
                                                              key: ValueKey(itemTask.id),
                                                              onDismissed: (direction) {
                                                                e.item!.removeWhere((element) => element.id == itemTask.id);
                                                                if (e.item!.isEmpty) {
                                                                  p.showDataCategoryWidget.removeWhere((element) => element.createdAt == e.createdAt);
                                                                  p.showDataCategoryWidget = p.showDataCategoryWidget;
                                                                }
                                                              },
                                                              direction: DismissDirection.endToStart,
                                                              background: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  color: Colors.green,
                                                                ),
                                                                child: Icon(
                                                                  Icons.delete_outline,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              child: Container(
                                                                width: double.infinity,
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  color: Colors.white,
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                      color: Color(0xffEBEDFF),
                                                                      blurRadius: 10.0,
                                                                      spreadRadius: 0,
                                                                      offset: Offset(0, 4),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.all(16),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        color: Colors.primaries[Random().nextInt(
                                                                          Colors.primaries.length,
                                                                        )],
                                                                      ),
                                                                      child: Icon(
                                                                        Icons.library_books_outlined,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            itemTask.title ?? '',
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 4),
                                                                          Text(
                                                                            itemTask.description ?? '',
                                                                            style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 4),
                                                                          Container(
                                                                            padding: EdgeInsets.all(6),
                                                                            decoration: BoxDecoration(
                                                                              color: itemTask.status == 'TODO'
                                                                                  ? Colors.green.withOpacity(0.2)
                                                                                  : itemTask.status == 'DOING'
                                                                                      ? Colors.amber.withOpacity(0.2)
                                                                                      : Colors.red.withOpacity(0.2),
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            child: Text(
                                                                              itemTask.status ?? '',
                                                                              style: TextStyle(
                                                                                  color: itemTask.status == 'TODO'
                                                                                      ? Colors.green
                                                                                      : itemTask.status == 'DOING'
                                                                                          ? Colors.amber
                                                                                          : Colors.red,
                                                                                  fontWeight: FontWeight.w600),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList()
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList()
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xffEBEDFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Hi! User\n',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(text: '\n'),
                            TextSpan(
                              text: 'Welcome\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '\n'),
                            TextSpan(text: 'to the category'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: IconButton(
                      onPressed: () => showChangeLockScreen(),
                      icon: Icon(
                        Icons.settings,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                ),
                Container(
                  margin: EdgeInsets.only(left: 32, right: 32, top: 0, bottom: 0),
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffF8F8F8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    padding: EdgeInsets.zero,
                    isScrollable: false,
                    indicatorWeight: 0,
                    physics: NeverScrollableScrollPhysics(),
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff9AC1FF),
                          Color(0xff92A3FE),
                        ],
                      ),
                    ),
                    tabs: CategoryStatus.values
                        .map(
                          (e) => Tab(
                            child: Text(
                              nameStatus(e),
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String nameStatus(CategoryStatus item) {
    switch (item) {
      case CategoryStatus.todo:
        return 'To-do';

      case CategoryStatus.doing:
        return 'Doing';

      case CategoryStatus.done:
        return 'Done';
    }
  }

  showLockScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String passcode = prefs.getString('passcode') ?? '123456';

    if (!mounted) return;
    screenLock(
      context: context,
      correctString: passcode,
      canCancel: false,
      useBlur: false,
      onUnlocked: () {
        Navigator.pop(context);
        categoryController.startTimer(
          callLockScreen: () => showLockScreen(),
        );
      },
      title: Column(
        children: [
          Text(
            'Please enter passcode',
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
      secretsConfig: SecretsConfig(
          secretConfig: SecretConfig(
        size: 20,
        borderColor: Colors.transparent,
        enabledColor: Color(0xFF92A3FE),
        disabledColor: Color(0xFFEBEDFF),
      )),
      config: ScreenLockConfig.defaultConfig.copyWith(
        themeData: ThemeData.light(),
        backgroundColor: Colors.white,
        buttonStyle: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF92A3FE),
          backgroundColor: Color(0xffEBEDFF),
          shape: CircleBorder(),
          padding: EdgeInsets.all(0),
          side: BorderSide.none,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  showChangeLockScreen() {
    categoryController.clearTimer();
    screenLockCreate(
      context: context,
      digits: 6,
      onConfirmed: (value) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('passcode', value);
        if (!mounted) return;
        Navigator.pop(context);
        categoryController.startTimer(callLockScreen: () => showLockScreen());
      },
      title: Column(
        children: [
          Text(
            'Please enter new passcode',
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
      confirmTitle: Column(
        children: [
          Text(
            'Please confirm new enter passcode',
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
      secretsConfig: SecretsConfig(
          secretConfig: SecretConfig(
        size: 20,
        borderColor: Colors.transparent,
        enabledColor: Color(0xFF92A3FE),
        disabledColor: Color(0xFFEBEDFF),
      )),
      config: ScreenLockConfig.defaultConfig.copyWith(
        themeData: ThemeData.light(),
        backgroundColor: Colors.white,
        buttonStyle: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF92A3FE),
          backgroundColor: Color(0xffEBEDFF),
          shape: CircleBorder(),
          padding: EdgeInsets.all(0),
          side: BorderSide.none,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
