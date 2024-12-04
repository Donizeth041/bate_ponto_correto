import 'package:bateponto/Telas/historico.dart';
import 'package:bateponto/Telas/login.dart';
import 'package:bateponto/Telas/pesquisa.dart';
import 'package:bateponto/Telas/ponto.dart';
import 'package:bateponto/Telas/profile.dart';
import 'package:bateponto/Telas/register.dart';
import 'package:bateponto/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bateponto/services/usuarioservice.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthService _auth = AuthService();
  final UsuarioService _usuarioService = UsuarioService();
  User? _user;
  String? _userType;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  // Função para verificar o status de login e o tipo de usuário
  void _checkUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Verifica o tipo de usuário (funcionário ou admin)
      var usuario = await _usuarioService.getUsuarioById(user.uid);
      setState(() {
        _user = user;
        _userType = usuario.tipo; // Pode ser 'admin' ou 'funcionario'
      });
    } else {
      setState(() {
        _user = null;
        _userType = null;
      });
    }
  }

  // Função para fazer logout
  void _logout() async {
    await _auth.signOut();
    setState(() {
      _user = null;
      _userType = null;
    });
  }

  // Função para construir os itens do Drawer de acordo com o tipo de usuário
  List<Widget> _buildDrawerItems(BuildContext context) {
    List<Widget> items = [
      _buildDrawerItem(
        context,
        icon: Icons.login,
        text: _user == null ? 'Login' : 'Logout',
        onTap: () {
          if (_user == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else {
            _logout();
          }
        },
      ),
    ];

    // Se o usuário estiver logado como funcionário
    if (_user != null && (_userType == 'funcionario' || _userType == 'admin')) {
      items.addAll([
        _buildDrawerItem(
          context,
          icon: Icons.person,
          text: 'Perfil',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          ),
        ),
        _buildDrawerItem(
          context,
          icon: Icons.history,
          text: 'Histórico',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HistoricoScreen()),
          ),
        ),
        _buildDrawerItem(
          context,
          icon: Icons.access_time,
          text: 'Bater Ponto',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PontoScreen()),
          ),
        ),
      ]);
    }

    // Se o usuário estiver logado como administrador
    if (_user != null && _userType == 'admin') {
      items.addAll([
        _buildDrawerItem(
          context,
          icon: Icons.person_add,
          text: 'Cadastrar',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          ),
        ),
        _buildDrawerItem(
          context,
          icon: Icons.search,
          text: 'Pesquisar',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PesquisaScreen()),
          ),
        ),
      ]);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ..._buildDrawerItems(context),
          ],
        ),
      ),
      body: Center(
        child: _user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bem-vindo ao sistema de bate-ponto!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    child: const Text('Registro'),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bem-vindo, ${_user?.displayName ?? 'Usuário'}!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
      ),
    );
  }

  // Método para criar os itens do Drawer
  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: onTap,
    );
  }
}
