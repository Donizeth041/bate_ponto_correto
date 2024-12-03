import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Para o admin
import 'funcionario_home.dart'; // Para o funcionário

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Função de login
  Future<void> login(String email, String senha) async {
    try {
      // Realiza a autenticação do usuário
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Obtém a referência do Firestore para a coleção de usuários
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .get();

      // Verifica o tipo de usuário
      String tipoUsuario = userDoc['tipo']; // 'admin' ou 'funcionario'

      // Redireciona para a tela de Bater Ponto após o login, dependendo do tipo de usuário
      if (tipoUsuario == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Tela do admin
        );
      } else if (tipoUsuario == 'funcionario') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FuncionarioHome()), // Tela do funcionário
        );
      }
    } catch (e) {
      print('Erro no login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao realizar o login: $e')));
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
