import 'package:app_foodtrunck/models/autenticacao.dart';
import 'package:app_foodtrunck/views/login_view.dart';
import 'package:app_foodtrunck/views/produtos_geral_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutenticacaoOuHomeView extends StatelessWidget {
  const AutenticacaoOuHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Autenticacao aut = Provider.of(context);
    return aut.estaAutenticado ? ProdutosGeralView() : const LoginView();
  }
}