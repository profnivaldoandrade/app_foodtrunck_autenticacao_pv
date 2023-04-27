import 'package:flutter/material.dart';

enum ModoLogin { Registrar, Login }

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final ModoLogin _modoLogin = ModoLogin.Login;
  Map<String, String> _dadosLogin = {
    'email': '',
    'password': '',
  };
  void _submit() {}

  @override
  Widget build(BuildContext context) {
    final tamanhoTela = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.only(top: 30),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: tamanhoTela.width * 0.75,
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'E-mail', icon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _dadosLogin['email'] = email ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Senha', icon: Icon(Icons.key)),
                keyboardType: TextInputType.text,
                obscureText: true,
                onSaved: (password) => _dadosLogin['passeord'] == password ?? '',
              ),
              if (_modoLogin == ModoLogin.Registrar)
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Confirmar Senha', icon: Icon(Icons.key)),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  _modoLogin == ModoLogin.Login ? 'ENTRAR' : 'REGISTRAR',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
