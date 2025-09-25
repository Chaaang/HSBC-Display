import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/constants/api_config.dart';
import '../domain/entities/signature_url.dart';
import '../domain/repo/signature_repo.dart';

class ApiSignatureRepo implements SignatureRepo {
  String url = ApiConfig.baseUrl;
  @override
  Future<List<SignatureUrl>> getSignatures(String signId) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'key': 'fsop25#09dt',
          'table_name': 'signs',
          'action': 'images',
          'signs_id': signId,
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody is List) {
          return jsonBody.map((e) => SignatureUrl.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
