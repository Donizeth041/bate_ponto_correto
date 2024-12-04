import 'package:bateponto/Telas/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:bateponto/services/authservice.dart'; // Importe o AuthService
import 'package:bateponto/services/usuarioservice.dart'; // Importe o AuthService
import 'package:firebase_auth/firebase_auth.dart'; // Importe o UsuarioService
import 'package:bateponto/models/usuario.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedTipo = 'funcionario'; // Tipo padrão
  final AuthService _authService = AuthService();
  final UsuarioService _usuarioService = UsuarioService();

  // Função de registro
  Future<void> _register() async {
    try {
      // Cria o usuário no Firebase Authentication
      //
      final email = _emailController.text;
      final password = _passwordController.text;
      UserCredential? userCredential =
          await _authService.createUserWithEmailPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        Usuario newUser = Usuario(
            id: userCredential.user!.uid,
            email: _emailController.text,
            tipo: _selectedTipo,
            nome: _nameController.text);

        await _usuarioService.createUsuario(newUser);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Usuário registrado com sucesso!'),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen()), // Tela do admin
        );
      }
      // Salva os dados do usuário no Firestore

      // Redireciona para a tela de login após o cadastro
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
            // Campo de email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 10),
            // Campo de senha
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20),
            // Dropdown para selecionar tipo de usuário
            DropdownButton<String>(
              value: _selectedTipo,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTipo = newValue!;
                });
              },
              items: <String>['funcionario', 'admin']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Botão de registro
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
