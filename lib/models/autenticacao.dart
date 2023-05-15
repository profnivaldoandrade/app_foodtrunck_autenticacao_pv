import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Autenticacao with ChangeNotifier {
  static const _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCF805VMvrJu6SRVawzsCZ7txe60k3RRRg';

  Future<void> _autenticacao(
      String email, String password, String urlFragmento) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragmento?key=AIzaSyCF805VMvrJu6SRVawzsCZ7txe60k3RRRg';
    final resposta = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    print(jsonDecode(resposta.body));
  }

  Future<void> registrar(String email, String password) async {
   return _autenticacao(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _autenticacao(email, password, 'signInWithPassword');
  }
}
