import 'package:app_foodtrunck/models/autenticacao.dart';
import 'package:app_foodtrunck/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem Vindo Usuário!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Food Trunck'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.LOGIN_OU_HOME,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Meus Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.FECHAR_PEDIDO,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.PRODUTOS,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Autenticacao>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.LOGIN_OU_HOME,
              );
            },
          ),
        ],
      ),
    );
  }
}
