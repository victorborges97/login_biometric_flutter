import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:login_biometric/HomeScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BiometricLoginScreen(),
    );
  }
}

class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});
  @override
  _BiometricLoginScreenState createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  final _localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffold = ScaffoldMessenger.of(context);

                // Verifica se o dispositivo suporta autenticação biométrica
                final bool canAuthenticateWithBiometrics =
                    await _localAuth.canCheckBiometrics;
                final isAvailable = await _localAuth.isDeviceSupported();

                if (isAvailable || canAuthenticateWithBiometrics) {
                  try {
                    // Exibe o diálogo de autenticação biométrica
                    final authenticated = await _localAuth.authenticate(
                        localizedReason:
                            'Faça a autenticação biométrica para fazer login',
                        options: AuthenticationOptions(
                          biometricOnly: true,
                          stickyAuth: true,
                          useErrorDialogs: true,
                        ));

                    if (authenticated) {
                      // Redirecione para a tela principal
                      navigator.pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      // Autenticação biométrica falhou
                      scaffold.showSnackBar(
                        const SnackBar(
                          content: Text('Falha na autenticação biométrica'),
                        ),
                      );
                    }
                  } on PlatformException catch (e) {
                    if (e.code == auth_error.notAvailable) {
                      print('notAvailable: ${e.message}');
                    } else if (e.code == auth_error.notEnrolled) {
                      print('notEnrolled: ${e.message}');
                    } else {
                      print('PlatformException: ${e.message}');
                    }
                  } catch (e) {
                    print('Erro: $e');
                  }
                } else {
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                          'A autenticação biométrica não está disponível neste dispositivo'),
                    ),
                  );
                }
              },
              child: const Text('Login com Biometria'),
            ),
          ],
        ),
      ),
    );
  }
}
