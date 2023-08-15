import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:test_robinhood/screen/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff92A3FE)),
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      }),
      home: SplashScreen(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60
    ..textColor = Colors.black
    ..radius = 20
    ..backgroundColor = Colors.transparent
    ..maskColor = Colors.white
    ..indicatorColor = Color(0xff92A3FE)
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[]
    ..userInteractions = false
    ..dismissOnTap = false;
}
