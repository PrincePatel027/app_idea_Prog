import 'package:app_idea_prog/provider/log_in_provider.dart';
import 'package:app_idea_prog/provider/post_provider.dart';
import 'package:app_idea_prog/views/pages/add_post_page.dart';
import 'package:app_idea_prog/views/pages/login_page.dart';
import 'package:app_idea_prog/views/pages/sign_up.dart';
import 'package:app_idea_prog/views/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/pages/home_page.dart';
import 'provider/sign_up_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        initialRoute: 'splash',
        routes: {
          '/': (_) => const HomePage(),
          'splash': (_) => const SplashScreen(),
          'sign_up': (_) => const SignUPPage(),
          'login': (_) => const LoginPage(),
          'add_post': (_) => const AddPostPage(),
        },
      ),
    );
  }
}


// lib/
// ├── models/
// ├── views/
// ├── controllers/
// ├── utils/
// │   └── size_utils.dart
// └── main.dart