import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carregar as informações do usuário no inicial
    _loadUserData();
  }

  // Função para carregar as informações do usuário
  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Carregar o documento do usuário no Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      setState(() {
        _nameController.text = userDoc['name'] ?? user.displayName ?? '';
        _emailController.text = user.email ?? '';
      });
    }
  }

  // Função para salvar as informações alteradas no Firestore
  void _saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Atualizando informações no Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
        });

        // Atualizando o email do usuário
        if (_emailController.text != user.email) {
          await user.updateEmail(_emailController.text);
        }

        // Se houver senha informada, atualiza também
        if (_passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text);
        }

        // Sucesso na atualização
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perfil atualizado com sucesso!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar perfil: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Perfil do Usuário', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Nova Senha (opcional)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Salvar Alterações',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
