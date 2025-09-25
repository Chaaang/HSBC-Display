import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../shared/constants/api_config.dart';
import '../domain/entities/sign_model.dart';
import '../domain/repo/sign_repo.dart';

class ApiHomeRepo implements SignRepo {
  String url = ApiConfig.baseUrl;
  @override
  Future<SignModel?> getSignItem(String uuid) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'key': 'fsop25#09dt',
          'table_name': 'signs',
          'action': 'lists',
          'members_id': uuid,
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody is List && jsonBody.isNotEmpty) {
          return SignModel.fromJson(jsonBody.first);
        } else {
          return null;
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> uploadSign(Uint8List bytes, String userId, String signId) async {
    try {
      // Encode to base64
      final base64Image = base64Encode(bytes);

      // Add prefix (choose "png" or "jpeg" depending on your image)
      final dataUriImage = "data:image/png;base64,$base64Image";

      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl),
        body: {
          'key': 'fsop25#09dt',
          'table_name': 'signs',
          'action': 'upload',
          'members_id': userId,
          'signs_id': signId,
          'fileimage': dataUriImage, // <-- with prefix
        },
      );

      if (response.statusCode == 200) {
        // final body = response.body;
        // print(body);
      } else {
        throw Exception(
          "Upload failed with status ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      rethrow; // so your Cubit can emit SignError
    }
  }
}
