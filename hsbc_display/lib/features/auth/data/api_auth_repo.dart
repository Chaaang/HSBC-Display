import 'dart:convert';

import 'package:hsbc_display/features/auth/domain/repo/auth_repo.dart';
import 'package:http/http.dart' as http;

import '../../shared/constants/api_config.dart';
import '../domain/entities/login_response.dart';

class ApiAuthRepo implements AuthRepo {
  String url = ApiConfig.baseUrl;
  @override
  Future<LoginResponse?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'key': 'fsop25#09dt',
          'table_name': 'members',
          'action': 'login',
          'accounts_login': username,
          'accounts_password': password,
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody is List) {
          // Success case
          final item = jsonBody.first;
          return LoginResponse(id: item['id'], title: item['title_1']);
        } else if (jsonBody is Map && jsonBody.containsKey('error_code')) {
          // Failure case
          throw Exception(jsonBody['message']); // or return null
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Server error ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
