import 'dart:convert';

import 'package:http/http.dart' as http;

class VmLogin {
  static const loginUrl = 'https://brandz.nevinainfotech.co.in/api/login';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<String> login(String email, String pass) async {
    try {
      final body = json.encode({
        "device_type": "android",
        "device_token": "",
        "email": email,
        "password": pass,
        "locale": "en"
      });
      final res = await http.post(
        Uri.parse(loginUrl),
        body: body,
        headers: requestHeaders,
      );
      final data = json.decode(res.body);
      return data['message'];
    } catch (e) {
      return e.toString();
    }
  }
}
