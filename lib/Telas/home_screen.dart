import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  // Função de logout
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(
        context, '/login'); // Redireciona para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Principal'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navegar para a tela de Bater Ponto
            Navigator.pushReplacementNamed(context, '/ponto');
          },
          child: Text('Ir para Bater Ponto'),
        ),
      ),
    );
  }
}
