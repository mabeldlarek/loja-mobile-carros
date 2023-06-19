import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_veiculos/data/session.dart';

import '../repository/vendedor_repository.dart';
import '../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Image.asset(
                      'assets/icon/icone.png',
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      initialValue: _formData['email'],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '*E-mail',
                      ),
                      validator: (value) {
                        if (value != null) {
                          if (!EmailValidator.validate(value!)) {
                            return "Email inválido";
                          }
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['email'] = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      obscureText: !_showPassword,
                      initialValue: _formData['senha'],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: '*Senha',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value != null) {
                          if (value.length < 5 || value.length > 10) {
                            return "Senha inválida";
                          }
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['senha'] = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        final isValid = _form.currentState!.validate();

                        if (isValid) {
                          _form.currentState?.save();

                          _login();
                        }
                      },
                      child: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(300, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    switch (await Provider.of<VendedorRepository>(context, listen: false)
        .getLogin(_formData['email'], _formData['senha'])) {
      case 1:
        Navigator.pushNamed(context, AppRoutes.administradorHome);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.vendedorHome);
        break;
      default:
        print("inválido");
    }
  }
}
