import 'package:app_foodtrunck/models/pedido.dart';
import 'package:app_foodtrunck/models/produto.dart';
import 'package:app_foodtrunck/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProdutoDetalheView extends StatelessWidget {
  const ProdutoDetalheView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Produto produto =
        ModalRoute.of(context)!.settings.arguments as Produto;
    //final produto = Provider.of<Produto>(context, listen: true); eita
    final pedido = Provider.of<Pedido>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            produto.titulo,
            style: const TextStyle(fontSize: 25),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  produto.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Ingredientes',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                width: 400,
                height: 280,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: ListView.builder(
                    itemCount: produto.ingredientes.length,
                    itemBuilder: (cxt, i) {
                      return Card(
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            produto.ingredientes[i],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 100,
                child: Column(
                  children: [
                    Text(
                      produto.descricao,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 35,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        label: Text(
                          'R\$ ${produto.preco}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          pedido.addItem(produto);
                          Navigator.of(context)
                              .pushNamed(AppRoutes.LOGIN_OU_HOME);
                        },
                        child: const Text('ADICIONAR NO PEDIDO'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
