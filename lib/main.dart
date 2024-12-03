import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Telas/login.dart';
import 'Telas/register.dart';
import 'Telas/profile.dart';
import 'Telas/historico.dart';
import 'Telas/ponto.dart';
import 'Telas/pesquisa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCQsGNTsmwifj06uEE1m7mbrU1Qf4u2STA",
      authDomain: "bate-ponto-fa7a1.firebaseapp.com",
      projectId: "bate-ponto-fa7a1",
      storageBucket: "bate-ponto-fa7a1.appspot.com",
      messagingSenderId: "821347773206",
      appId: "1:821347773206:web:87975141e0e0f2963dfe37",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bate-Ponto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal'),
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
            _buildDrawerItem(
              context,
              icon: Icons.login,
              text: 'Login',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ),
            ),
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
            _buildDrawerItem(
              context,
              icon: Icons.search,
              text: 'Pesquisar',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PesquisaScreen()),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

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
