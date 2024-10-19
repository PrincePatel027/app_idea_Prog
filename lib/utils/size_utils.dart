import 'package:flutter/material.dart';

class SizeUtils {
  static double getScreenHeight({required BuildContext context}) {
    return MediaQuery.sizeOf(context).height;
  }

  static double getScreenWidth({required BuildContext context}) {
    return MediaQuery.sizeOf(context).width;
  }
}
