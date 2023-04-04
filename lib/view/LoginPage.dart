import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
       body: Column(
            children: const [
              Center(
                heightFactor: 2,
                child: Text(
                  'Teste!',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 32,
                  color: Colors.black,
                  )
                ),
              ),
            ]
      ),
    );
  }

}