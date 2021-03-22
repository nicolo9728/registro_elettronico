import 'package:http/http.dart' as http;
import 'package:registro/models/Utente.dart';

class HttpRequest {
  static Map<String, String> get _header => {"Authorization": Utente.utenteLoggato?.token ?? "", "Content-Type": "application/json"};

  static Future<String> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: _header);

    if (response.statusCode == 400 || response.statusCode == 500)
      throw new Exception(response.body);
    else
      return response.body;
  }

  static Future<String> post(String url, String json) async {
    http.Response response = await http.post(Uri.parse(url), body: json, headers: _header);

    if (response.statusCode == 400 || response.statusCode == 500)
      throw new Exception(response.body);
    else
      return response.body;
  }
}
