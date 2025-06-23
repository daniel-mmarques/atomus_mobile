import 'dart:async';
import 'package:atomus/models/local_storage.dart';
import 'package:atomus/models/user.dart';
import 'package:dio/dio.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<User> save(User user) async {
    try {
      final Map<String, dynamic> userBody = {
        "name": user.name,
        "cpf": user.cpf,
        "email": user.email,
        "password": user.password,
      };

      var response =
          await _dio.post('/usuario', data: userBody, options: Options());

      if (response.statusCode == 201) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Erro ao salvar usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<String> login(User user) async {
    try {
      final Map<String, dynamic> userBody = {
        "username": user.email,
        "password": user.password.toString(),
      };

      var response =
          await _dio.post('/login', data: userBody, options: Options());

      if (response.statusCode == 200) {
        int id = response.data['Id'];
        String token = response.data['token'];

        await LocalStorage.saveToken(token);
        await LocalStorage.saveUserId(id);

        _dio.options.headers['Authorization'] = 'Bearer $token';

        return token;
      } else {
        throw Exception('Erro no login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<void> delete(int userId) async {
    try {
      var response = await _dio.delete('/negociacao/$userId');

      if (response.statusCode != 204) {
        throw Exception('Erro ao deletar usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}
