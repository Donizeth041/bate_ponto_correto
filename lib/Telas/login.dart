import 'package:bateponto/Telas/mainscreen.dart';
import 'package:bateponto/services/usuarioservice.dart';
import 'package:flutter/material.dart';
import 'package:bateponto/services/authservice.dart'; // Importe o AuthService
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bateponto/models/usuario.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService(); // Instância do AuthService
  final UsuarioService _userService =
      UsuarioService(); // Instância do AuthService

  // Função de login
  Future<void> login(String email, String senha) async {
    try {
      // Realiza o login através do AuthService
      UserCredential? userCredential =
          await _auth.signInWithEmailPassword(email: email, password: senha);

      if (userCredential != null) {
        // Obtém o tipo de usuário após o login
        Usuario usuario =
            await _userService.getUsuarioById(userCredential.user!.uid);
        String tipoUsuario = usuario.tipo;

        // Redireciona para a tela apropriada com base no tipo de usuário

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen()), // Tela do admin
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email e/ou senha incorretos!')));
      }
    } catch (e) {
      print('Erro no login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao realizar o login: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Campo de senha
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20),
            // Botão de login
            ElevatedButton(
              onPressed: () {
                // Chama a função de login
                login(
                  _emailController.text,
                  _passwordController.text,
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
