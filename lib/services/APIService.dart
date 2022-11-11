import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIService {
  static String? username;
  static String? password;
  static int? loggedUserId;
  String? route;

  APIService({this.route});

  void SetParameters(String Username, String Password, int LoggedUserId) {
    username = Username;
    password = Password;
    loggedUserId = LoggedUserId;
  }

  static Future<List<dynamic>?> Get(String route, [dynamic object]) async {
    String queryParams = Uri(queryParameters: object).query;
    String baseUrl = "http://192.168.0.26:44366/api/" + route;
    if (object != null) {
      baseUrl = baseUrl + '?' + queryParams;
    }
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(Uri.parse(baseUrl),
        headers: {HttpHeaders.authorizationHeader: basicAuth});
    if (response.statusCode == 200) {
      return JsonDecoder().convert(response.body);
    }
    return null;
  }
}
