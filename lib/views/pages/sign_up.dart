import 'package:app_idea_prog/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../provider/sign_up_provider.dart';

class SignUPPage extends StatefulWidget {
  const SignUPPage({super.key});

  @override
  State<SignUPPage> createState() => _SignUPPageState();
}

class _SignUPPageState extends State<SignUPPage> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    await DbHelper.dbHelper.initDB();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: provider.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Hey, Hello 👋',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your credentials to Create account',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/google.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text('Google'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                    ),
                    const SizedBox(width: 20),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/apple.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text('Apple'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'or',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Name'),
                const SizedBox(height: 5),
                TextFormField(
                  controller: provider.nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Email address'),
                const SizedBox(height: 5),
                TextFormField(
                  controller: provider.emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Email address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Password'),
                const SizedBox(height: 5),
                TextFormField(
                  controller: provider.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Password',
                    suffixIcon: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: provider.termsAccepted,
                      onChanged: provider.toggleTermsCondition,
                    ),
                    const Text('I agree to the'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Terms & Privacy'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    onPressed: () async {
                      if (provider.validateForm()) {
                        try {
                          int? res = await DbHelper.dbHelper.singUp(
                            username: provider.nameController.text,
                            email: provider.emailController.text,
                            password: provider.passwordController.text,
                          );

                          provider.nameController.clear();
                          provider.emailController.clear();
                          provider.passwordController.clear();

                          if (res != null && res >= 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Data Inserted Successfully...',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Data Insertion Failed...',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } on DatabaseException catch (e) {
                          if (e.isUniqueConstraintError()) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Username or Email already exists.'),
                                  actions: <Widget>[
                                    OutlinedButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                    ),
                    child: const Text('Log In'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "login");
                    },
                    child: const Text('Have an account? Log-in'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
