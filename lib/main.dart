import 'package:app_foodtrunck/models/autenticacao.dart';
import 'package:app_foodtrunck/models/pedido.dart';
import 'package:app_foodtrunck/models/fechar_pedidos_itens.dart';
import 'package:app_foodtrunck/models/lista_produtos.dart';
import 'package:app_foodtrunck/utils/app_routes.dart';
import 'package:app_foodtrunck/views/autenticacao_ou_home_view.dart';
import 'package:app_foodtrunck/views/form_produto_view.dart';
import 'package:app_foodtrunck/views/login_view.dart';
import 'package:app_foodtrunck/views/pedido_view.dart';
import 'package:app_foodtrunck/views/fechar_pedido_view.dart';
import 'package:app_foodtrunck/views/produto_detalhe_view.dart';
import 'package:app_foodtrunck/views/produtos_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Autenticacao()),
        ChangeNotifierProxyProvider<Autenticacao, ListaProdutos>(
          create: (_) => ListaProdutos('',[]),
          update: (cxt, aut, anterior) {
            return ListaProdutos(aut.token ?? '', anterior?.items ?? []);
          },
        ),
        ChangeNotifierProvider(create: (_) => Pedido()),
        ChangeNotifierProvider(create: (_) => FecharPedidoItens()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // ignore: prefer_const_constructors
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: const Color.fromARGB(255, 223, 86, 5),
            onPrimary: const Color.fromARGB(255, 242, 245, 242),
            secondary: const Color.fromARGB(255, 143, 24, 0),
            onSecondary: const Color.fromARGB(255, 70, 186, 105),
            error: const Color.fromARGB(255, 247, 5, 5),
            onError: const Color.fromARGB(255, 143, 24, 0),
            background: const Color.fromARGB(255, 60, 46, 33),
            onBackground: const Color.fromARGB(255, 60, 46, 33),
            surface: const Color.fromARGB(255, 238, 201, 182),
            onSurface: const Color.fromARGB(255, 0, 0, 0),
          ),

          // Define the default font family.
          fontFamily: 'Lato',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 24, fontFamily: 'Lato-Bold'),
            bodyLarge: TextStyle(
                fontSize: 15,
                fontFamily: 'Lato',
                color: Color.fromARGB(255, 184, 5, 5)),
            bodyMedium: TextStyle(
                fontSize: 20, fontFamily: 'Lato', color: Colors.white),
            bodySmall: TextStyle(
                fontSize: 20, fontFamily: 'Lato', color: Colors.black),
          ),
        ),
        //home: ProdutosGeralView(),
        routes: {
          AppRoutes.PRODUTO_DETALHES: (context) => const ProdutoDetalheView(),
          AppRoutes.PEDIDO: (context) => const PedidoView(),
          AppRoutes.FECHAR_PEDIDO: (context) => const FecharPedidoView(),
          AppRoutes.PRODUTOS: (context) => const ProdutosView(),
          AppRoutes.PRODUTO_FORM: (context) => const FormProdutoView(),
          AppRoutes.LOGIN_OU_HOME: (context) => const AutenticacaoOuHomeView(),
        },
      ),
    );
  }
}
