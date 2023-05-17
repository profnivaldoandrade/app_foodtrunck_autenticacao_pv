import 'dart:convert';

import 'package:app_foodtrunck/utils/app_constantes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Produto with ChangeNotifier {
  final String id;
  final String titulo;
  final String descricao;
  final List ingredientes;
  final double preco;
  final String imgUrl;
  bool eFavorito;

  Produto(
      {required this.id,
      required this.titulo,
      required this.descricao,
      required this.ingredientes,
      required this.preco,
      required this.imgUrl,
      this.eFavorito = false});

  void _alternarFavorito() {
    eFavorito = !eFavorito;
    notifyListeners();
  }

  Future<void> alternarFavorito(String token, String userId) async {
    _alternarFavorito();
    final resposta = await http.put(
      Uri.parse('${AppConstantes.USUARIO_FAVORITO_URL}/$userId/$id.json?auth=$token'),
      body: jsonEncode(eFavorito),
    );

    if (resposta.statusCode >= 400) {
      _alternarFavorito();
    }
  }
}
