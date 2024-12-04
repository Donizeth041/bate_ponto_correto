import 'package:bateponto/Telas/mainscreen.dart';
import 'package:bateponto/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bateponto/services/authservice.dart'; // Certifique-se de que AuthService esteja importado
import 'package:bateponto/services/usuarioservice.dart'; // Certifique-se de que UsuarioService esteja importado

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService(); // Instância do AuthService
  final UsuarioService _usuarioService =
      UsuarioService(); // Instância do UsuarioService

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
      // Carregar o nome do usuário no Firestore através do UsuarioService
      var usuario = await _usuarioService.getUsuarioById(user.uid);
      setState(() {
        _nameController.text = usuario.nome; // Supondo que o campo seja 'name'
      });
    }
  }

  // Função para salvar as informações alteradas no Firestore
  void _saveProfile() async {
    User? user = _authService.currentUser;
    if (user != null) {
      try {
        Usuario usuario = await _usuarioService.getUsuarioById(user.uid);
        Usuario updateUser = Usuario(
            id: usuario.id,
            nome: _nameController.text,
            email: usuario.email,
            tipo: usuario.tipo);

        // Atualizando o nome no Firestore
        await _usuarioService.updateUsuario(updateUser);

        // Sucesso na atualização
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perfil atualizado com sucesso!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar perfil: $e')));
      }
    }
  }

  // Função para enviar um email de reset de senha utilizando o AuthService
  void _resetPassword() async {
    User? user = _authService.currentUser;
    if (user != null) {
      try {
        await _authService.resetPassword(user.email!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Link de reset de senha enviado! Verifique seu e-mail.'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao enviar link de reset de senha: $e'),
        ));
      }
    }
  }

  // Função para excluir a conta do usuário
  void _deleteAccount() async {
    User? user = _authService.currentUser;
    if (user != null) {
      try {
        // Excluindo a conta do Firebase Auth
        await user.delete();
        await _usuarioService.deleteUsuario(user.uid);
        // Se a conta for excluída, devemos limpar a UI
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Conta excluída com sucesso!'),
        ));
        // Redirecionar o usuário para a tela inicial ou login após excluir a conta
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen()), // Tela do admin
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao excluir conta: $e'),
        ));
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Salvar Alterações',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            SizedBox(height: 30),
            Text(
              'Redefinir Senha:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Enviar Link de Redefinição de Senha',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            SizedBox(height: 30),
            Text(
              'Excluir Conta:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteAccount,
              child: Text('Excluir Conta Permanentemente',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
