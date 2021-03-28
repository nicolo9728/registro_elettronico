import 'package:http/http.dart' as http;
import 'package:registro/models/Utente.dart';

class HttpRequest {
  static Map<String, String> get _header => {"Authorization": Utente.token ?? "", "Content-Type": "application/json"};
  static final String DOMINIO = "http://192.168.1.148:5000";

  static Future<String> get(String url) async {
    http.Response response = await http.get(Uri.parse(DOMINIO + url), headers: _header);
    if (response.statusCode == 400 || response.statusCode == 500)
      throw new Exception(response.body);
    else
      return response.body;
  }

  static Future<String> post(String url, String json) async {
    http.Response response = await http.post(Uri.parse(DOMINIO + url), body: json, headers: _header);

    if (response.statusCode == 400 || response.statusCode == 500)
      throw new Exception(response.body);
    else
      return response.body;
  }
}
