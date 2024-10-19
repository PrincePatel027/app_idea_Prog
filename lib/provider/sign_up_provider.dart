import 'dart:developer';

import 'package:flutter/material.dart';

class SignUpProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _termsAccepted = false;
  bool get termsAccepted => _termsAccepted;

  void toggleTermsCondition(bool? value) {
    _termsAccepted = value ?? false;
    notifyListeners();
  }

  bool validateForm() {
    log(nameController.text);
    log(emailController.text);
    log(passwordController.text);
    return formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
