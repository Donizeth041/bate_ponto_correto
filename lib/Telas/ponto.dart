import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bateponto/services/authservice.dart'; // Importe o AuthService
import 'package:bateponto/services/pontoservice.dart'; // Importe o PontoService

class PontoScreen extends StatefulWidget {
  @override
  _PontoScreenState createState() => _PontoScreenState();
}

class _PontoScreenState extends State<PontoScreen> {
  bool pontoAberto = false; // Determina se o ponto está aberto
  bool pontoFechado = false; // Determina se o ponto foi fechado
  late String usuarioId;
  final AuthService _authService = AuthService(); // Instância do AuthService
  final PontoService _pontoService =
      PontoService(); // Instância do PontoService

  // Função para verificar o último ponto aberto do usuário
  Future<void> verificarPonto() async {
    User? user = _authService.currentUser;
    if (user == null) {
      print('Usuário não autenticado');
      return;
    }

    usuarioId = user.uid;

    // Buscar o último ponto do usuário
    var ultimoPonto = await _pontoService.getUltimoPonto(usuarioId);

    setState(() {
      if (ultimoPonto != null && ultimoPonto['saida'] == null) {
        pontoAberto = true; // Se o ponto não tiver saída, ele está aberto
        pontoFechado = false;
      } else {
        pontoAberto = false;
        pontoFechado =
            false; // Se não tiver ponto ou já tiver saída, o ponto não está aberto
      }
    });
  }

  // Função para registrar o ponto (aberto ou fechado)
  Future<void> registrarPonto(bool aberto) async {
    User? user = _authService.currentUser;
    if (user == null) {
      print('Usuário não autenticado');
      return;
    }

    usuarioId = user.uid;

    await _pontoService.registrarPonto(
        usuarioId, aberto); // Usa o PontoService para registrar o ponto

    setState(() {
      pontoAberto = aberto;
      pontoFechado = !aberto; // Se abriu o ponto, o ponto não está fechado
    });
  }

  // Função para fechar o ponto mais recente
  Future<void> fecharPonto() async {
    User? user = _authService.currentUser;
    if (user == null) {
      print('Usuário não autenticado');
      return;
    }

    usuarioId = user.uid;

    // Fechar o último ponto aberto
    await _pontoService.fecharUltimoPonto(usuarioId);

    setState(() {
      pontoAberto = false;
      pontoFechado = true; // Marcar o ponto como fechado
    });
  }

  @override
  void initState() {
    super.initState();
    verificarPonto(); // Verificar o status do ponto ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bater Ponto', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (pontoFechado)
              // Se o ponto estiver fechado, exibe uma mensagem
              Text(
                'Ponto fechado com sucesso!',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            if (!pontoFechado)
              // Se o ponto não estiver fechado, permite abrir ou fechar
              pontoAberto
                  ? ElevatedButton(
                      onPressed: pontoFechado
                          ? null // Desabilita o botão se o ponto já foi fechado
                          : () async {
                              await fecharPonto(); // Fechar o ponto
                            },
                      child: Text(
                        'Fechar Ponto',
                        style: TextStyle(color: Colors.white),
                      ),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    )
                  : ElevatedButton(
                      onPressed: pontoFechado
                          ? null // Desabilita o botão se o ponto já foi fechado
                          : () async {
                              await registrarPonto(true); // Abre o ponto
                            },
                      child: Text(
                        'Abrir Ponto',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
          ],
        ),
      ),
    );
  }
}
