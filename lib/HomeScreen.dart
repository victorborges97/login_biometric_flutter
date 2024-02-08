import 'package:flutter/material.dart';
import 'package:login_biometric/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const BiometricLoginScreen(),
                ),
              );
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
