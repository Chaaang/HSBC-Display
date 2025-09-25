import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/constants/api_config.dart';
import '../domain/entities/event.dart';
import '../domain/repo/event_repo.dart';

class ApiEventRepo implements EventRepo {
  String url = ApiConfig.baseUrl;
  @override
  Future<List<Event>> getEventItems(String uuid) async {
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

        if (jsonBody is List) {
          return jsonBody.map((e) => Event.fromJson(e)).toList();
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
