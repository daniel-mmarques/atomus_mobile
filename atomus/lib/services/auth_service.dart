import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? id = prefs.getInt('id');
    return token != null && token.isNotEmpty && id != null;
  }
}
