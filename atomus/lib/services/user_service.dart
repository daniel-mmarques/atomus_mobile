import 'package:atomus/models/user.dart';
import 'package:atomus/pages/splash_screen.dart';
import 'package:atomus/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final UserRepository _userRepository;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  UserService(this._userRepository);

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    notifyListeners();

    try {
      final user = User.login(
        email: email,
        password: password,
      );

      final token = await _userRepository.login(user);

      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Splashscreen(), // Replace with your home screen
          ),
        );
      } else {
        hasError = true;
        errorMessage = 'Usuário ou senha inválidos';
        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('Erro ao logar usuário: $e\n$stackTrace');
      hasError = true;
      errorMessage = 'Erro ao realizar login';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
