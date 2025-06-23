import 'package:atomus/pages/login_page.dart';
import 'package:atomus/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

class CheckAuthPage extends StatefulWidget {
  const CheckAuthPage({super.key});

  @override
  _CheckAuthPageState createState() => _CheckAuthPageState();
}

class _CheckAuthPageState extends State<CheckAuthPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await AuthService.isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Splashscreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
