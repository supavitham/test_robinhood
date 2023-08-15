import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_robinhood/controller/category_controller/category_controller.dart';
import 'package:provider/provider.dart';
import 'package:test_robinhood/screen/category_screen/category_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? passcode = prefs.getString('passcode');
      if (passcode == null) {
        await prefs.setString('passcode', '123456');
      }

      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<CategoryController>(
            create: (context) => CategoryController(context),
            child: CategoryScreen(),
          ),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/logo.JPG',
            height: MediaQuery.of(context).size.height * 0.2,
          ),
        ],
      ),
    );
  }
}
