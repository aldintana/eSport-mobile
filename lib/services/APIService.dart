import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:core';

class APIService {
  static String username = "";
  static String password = "";
  static int loggedUserId = 0;
  String route = "";

  APIService({this.route = ""});

  void SetParameters(String Username, String Password, int LoggedUserId) {
    username = Username;
    password = Password;
    loggedUserId = LoggedUserId;
  }

  static Future<List<dynamic>?> Get(String route, [dynamic object, List<String>? includeList]) async {
    String queryParams = Uri(queryParameters: object).query;
    if(includeList != null && includeList.length > 0){
      includeList.asMap().forEach((index, element) {
        if(index == 0 && object == null){
          queryParams = "IncludeList=${element}";
        }
        else {
          queryParams += "&IncludeList=${element}";
        }
      });
    }
    String baseUrl = "http://192.168.0.33:44366/api/" + route;
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

  static Future<dynamic> Post(String route, String body) async {
    String baseUrl="http://192.168.0.33:44366/api/"+route;
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var response = null;
    print(body);
    if(username.isNotEmpty && password.isNotEmpty) {
      response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': basicAuth
        },
        body: body,
      );
    }
    else{
      response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: body,
      );
    }

    if(response.statusCode == 200 && response.body.isEmpty){
      return "200";
    }
    if(response.statusCode != 200 && response.body.isEmpty){
      return "500";
    }
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }
}
