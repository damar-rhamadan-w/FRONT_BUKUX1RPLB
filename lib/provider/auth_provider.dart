import 'dart:convert';
import 'package:bukuflutter/config/config_apps.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  final dynamic apiUrl = Uri.parse(ConfigApps.url);
  //Aes key 16 character
  //Routine Login(username,password)
  void setCurrentToken(String newToken){
    _token = newToken;
     _isAuthenticated = true;
    notifyListeners();
  }

  void removeCurrentToken(){
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final postBody = {'email': username, 'password': password};
    final response = await http.post(
        Uri.parse(ConfigApps.url + ConfigApps.login),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: postBody);
    Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['status']) {
     
      //Simpan Token
      setCurrentToken(responseData['token']);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  //periksa token di storage dan check ke backend
  Future<bool> loadTokenAndCheckAuth() async {
    final storedToken = token;
    if (storedToken != null) {
      final result = await _validateToken(storedToken);
      if (result) {
        _token = storedToken;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        //await logout();
        return false;
      }
    }else{
      return false;
    }
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await http.get(
        apiUrl + ConfigApps.check,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        removeCurrentToken();
        return false;
      }
    } catch (e) {
      removeCurrentToken();
      return false;
    }
  }

  Future<void> logout() async {
    final response =
        await http.get(
          Uri.parse(ConfigApps.url + ConfigApps.logout),
          headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            }
          );
    if (response.statusCode == 200) {
      removeCurrentToken();
      notifyListeners();
    }
  }
}