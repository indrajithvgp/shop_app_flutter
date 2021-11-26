import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTime;

  bool get isAuth {
    if (token != null) {
      return true;
    }
    return false;
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
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final URL =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=-fZINL2XfNAU";
      final response = await http.post(Uri.parse(URL),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

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
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'userData',
          json.encode({
            'userId': _userId,
            'token': _token,
            'expiryDate': _expiryDate.toIso8601String()
          }));
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

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    print(extractedData);
    final eDate = DateTime.parse(extractedData['expiryDate']);
    if (eDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = eDate;
    notifyListeners();
    _autoLogOut();
  }

  void logOut() {
    // print(_token);
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTime != null) {
      _authTime.cancel();
      _authTime = null;
    }
    notifyListeners();
  }

  void _autoLogOut() {
    if (_authTime != null) {
      _authTime.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
