import 'package:app_foodtrunck/components/app_drower.dart';
import 'package:app_foodtrunck/components/grid_produto.dart';
import 'package:app_foodtrunck/components/qtd_item_pedido.dart';
import 'package:app_foodtrunck/models/lista_produtos.dart';
import 'package:app_foodtrunck/models/pedido.dart';
import 'package:app_foodtrunck/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum OpcoesFiltro {
  // ignore: constant_identifier_names
  Favoritos,
  // ignore: constant_identifier_names
  Todos,
}

class ProdutosGeralView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ProdutosGeralView({super.key});

  @override
  State<ProdutosGeralView> createState() => _ProdutosGeralViewState();
}

class _ProdutosGeralViewState extends State<ProdutosGeralView> {
  bool _mostarApenasFavoritos = false;
  bool _estaCarregando = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ListaProdutos>(context, listen: false)
        .carregarProdutos()
        .then((value) {
      setState(() {
        _estaCarregando = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<ListaProdutos>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('FOOD TRANCK'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: OpcoesFiltro.Favoritos,
                child: Text('Somente Favotiros'),
              ),
              const PopupMenuItem(
                value: OpcoesFiltro.Todos,
                child: Text('Todos'),
              ),
            ],
            onSelected: (OpcoesFiltro valorSelecionado) {
              setState(() {
                if (valorSelecionado == OpcoesFiltro.Favoritos) {
                  //provider.mostraApenasFavoritos();
                  _mostarApenasFavoritos = true;
                } else {
                  //provider.mostraTodos();
                  _mostarApenasFavoritos = false;
                }
              });
            },
          ),
          Consumer<Pedido>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.PEDIDO);
              },
              icon: const Icon(Icons.list_alt),
            ),
            builder: (ctx, carrinho, child) => QtdItemCarrinho(
              valor: carrinho.quantosItens.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: _estaCarregando
          ? const Center(child: CircularProgressIndicator())
          : GridProduto(_mostarApenasFavoritos),
      drawer: const AppDrawer(),
    );
  }
}
