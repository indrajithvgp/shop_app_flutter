import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTime;

  bool get isAuth {
    if (token != null) {
      return true;
    }
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final URL =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key==x";
      final response = await http.post(Uri.parse(URL),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      autoLogOut();
      final responseData = json.decode(response.body);

      // print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  void logOut() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTime != null) {
      _authTime.cancel();
      _authTime = null;
    }
    notifyListeners();
  }

  void autoLogOut() {
    if (_authTime != null) {
      _authTime.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
