import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tipoController =
      TextEditingController(); // Campo para 'admin' ou 'funcionario'
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função de registro
  Future<void> _register() async {
    try {
      // Criar usuário no Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Salvar dados do usuário no Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text,
        'senha': _passwordController
            .text, // Embora não seja ideal armazenar senha em texto claro
        'tipo': _tipoController.text, // Pode ser 'admin' ou 'funcionario'
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Usuário registrado com sucesso!'),
      ));

      // Redirecionar para a tela de login após cadastro
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Falha no registro!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: _tipoController,
              decoration:
                  InputDecoration(labelText: 'Tipo (admin/funcionario)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
