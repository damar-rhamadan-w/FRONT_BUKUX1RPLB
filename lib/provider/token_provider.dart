import 'package:flutter/foundation.dart';


class TokenProvider extends ChangeNotifier {
  String? _currentToken;
  String? get getCurrentToken => _currentToken;
  void setCurrentToken(String newToken){
    _currentToken = newToken;
    notifyListeners();
  }
  void removeCurrentToken(){
    _currentToken=null;
    notifyListeners();
  }
}