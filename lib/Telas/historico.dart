import 'package:bateponto/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bateponto/services/authservice.dart';
import 'package:bateponto/services/usuarioservice.dart';
import 'package:bateponto/services/pontoservice.dart';
import 'package:bateponto/models/ponto.dart';

class HistoricoScreen extends StatefulWidget {
  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  String tipoUsuario = ''; // Vai armazenar o tipo de usuário
  final PontoService _pontoService = PontoService();
  final UsuarioService _usuarioService = UsuarioService();
  final AuthService _authService = AuthService();

  // Função para verificar o tipo de usuário
  Future<void> verificarTipoUsuario() async {
    User? user = _authService.currentUser;
    if (user != null) {
      try {
        Usuario usuario = await _usuarioService.getUsuarioById(user.uid);
        setState(() {
          tipoUsuario = usuario.tipo;
        });
      } catch (e) {
        print('Erro ao obter tipo de usuário: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    verificarTipoUsuario(); // Chama a função para verificar o tipo de usuário
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text('Histórico de Pontos', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: tipoUsuario.isEmpty // Verifica se o tipoUsuario está vazio
          ? Center(
              child:
                  CircularProgressIndicator()) // Exibe o loading enquanto carrega
          : tipoUsuario == 'admin'
              // Exibe todos os pontos para admin
              ? FutureBuilder<List<Ponto>>(
                  future: _pontoService.getAllPontos(), // Obtém todos os pontos
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Nenhum ponto registrado.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var ponto = snapshot.data![index];
                        return ListTile(
                          title: Text('Entrada: ${ponto.entrada}'),
                          subtitle: Text('Saída: ${ponto.saida}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _pontoService.deletePonto(ponto.id);
                              setState(() {});
                            },
                          ),
                        );
                      },
                    );
                  },
                )
              : // Exibe apenas os pontos do usuário logado para o funcionário
              FutureBuilder<List<Ponto>>(
                  future: _pontoService.getPontosByUsuario(_authService
                      .currentUser!.uid), // Obtém os pontos do usuário logado
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Nenhum ponto registrado.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var ponto = snapshot.data![index];
                        return ListTile(
                          title: Text('Entrada: ${ponto.entrada}'),
                          subtitle: Text('Saída: ${ponto.saida}'),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
