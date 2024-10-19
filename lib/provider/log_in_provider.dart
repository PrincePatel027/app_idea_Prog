import 'dart:developer';
import 'package:app_idea_prog/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  bool validateForm() {
    log(emailController.text);
    log(passwordController.text);
    return formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn(BuildContext context) async {
    if (validateForm()) {
      List? data = await DbHelper.dbHelper.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      if (data != null && data.isNotEmpty) {
        Map finalData = data[0];

        SharedPreferences preferences = await SharedPreferences.getInstance();

        preferences.setString("USERNAME", finalData['username']);
        preferences.setString("USEREMAIL", finalData['email']);
        preferences.setString("USERID", finalData['id'].toString());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Unsuccesfull..!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
