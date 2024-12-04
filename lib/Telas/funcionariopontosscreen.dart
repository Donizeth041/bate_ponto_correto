import 'package:flutter/material.dart';
import 'package:bateponto/services/pontoservice.dart'; // Importando PontoService
import 'package:bateponto/models/ponto.dart'; // Modelo de Ponto

class FuncionarioPontosScreen extends StatefulWidget {
  final String usuarioId;
  FuncionarioPontosScreen({required this.usuarioId});

  @override
  _FuncionarioPontosScreenState createState() =>
      _FuncionarioPontosScreenState();
}

class _FuncionarioPontosScreenState extends State<FuncionarioPontosScreen> {
  List<Ponto> _pontos = [];
  final PontoService _pontoService =
      PontoService(); // Instância do PontoService

  @override
  void initState() {
    super.initState();
    _loadPontos(); // Carregar os pontos do funcionário
  }

  // Função para carregar os pontos de um funcionário usando PontoService
  void _loadPontos() async {
    try {
      List<Ponto> pontos = await _pontoService.getPontosByUsuario(
          widget.usuarioId); // Carregar os pontos do usuário
      setState(() {
        _pontos = pontos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao carregar pontos: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Pontos do Funcionário',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _pontos.length,
        itemBuilder: (context, index) {
          var ponto = _pontos[index];
          return ListTile(
            title: Text('Entrada: ${ponto.entrada}'),
            subtitle: Text(
                'Saída: ${ponto.saida != null ? ponto.saida : "Não registrado"}'),
          );
        },
      ),
    );
  }
}
