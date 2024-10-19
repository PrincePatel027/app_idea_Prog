import 'dart:async';

import 'package:app_idea_prog/utils/size_utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;
  String location = "login";

  // checkLoggedInOrNot() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? output = preferences.getString("USERNAME");

  //   if (output != null && output == "") {
  //     location = "login";
  //   } else {
  //     location = "/";
  //   }
  // }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        Navigator.pushReplacementNamed(context, location);
        timer.cancel();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeUtils.getScreenHeight(context: context);
    double width = SizeUtils.getScreenWidth(context: context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(width * 0.068),
              height: height * 0.28,
              alignment: Alignment.center,
              child: Image.asset("assets/images/logo.png"),
            ),
          ],
        ),
      ),
    );
  }
}
