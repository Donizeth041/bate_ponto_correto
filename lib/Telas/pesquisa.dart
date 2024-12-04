import 'package:bateponto/Telas/funcionariopontosscreen.dart';
import 'package:flutter/material.dart';
import 'package:bateponto/services/usuarioservice.dart'; // Importando UsuarioService
import 'package:bateponto/models/usuario.dart';

class PesquisaScreen extends StatefulWidget {
  @override
  _PesquisaScreenState createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Usuario> _funcionarios = [];
  List<Usuario> _filteredFuncionarios = [];
  final UsuarioService _usuarioService =
      UsuarioService(); // Instância do UsuarioService

  @override
  void initState() {
    super.initState();
    _loadFuncionarios(); // Carregar todos os funcionários
  }

  // Função para carregar todos os funcionários usando UsuarioService
  void _loadFuncionarios() async {
    try {
      List<Usuario> funcionarios =
          await _usuarioService.getUsuarios(); // Carregar todos os usuários
      setState(() {
        _funcionarios = funcionarios;
        _filteredFuncionarios = funcionarios;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao carregar funcionários: $e'),
      ));
    }
  }

  // Função para buscar funcionários conforme o nome digitado
  void _searchFuncionarios(String nome) {
    setState(() {
      _filteredFuncionarios = _funcionarios
          .where((funcionario) =>
              funcionario.nome.toLowerCase().contains(nome.toLowerCase()))
          .toList();
    });
  }

  // Função para navegar para a tela de pontos do funcionário
  void _openFuncionarioPontosScreen(String usuarioId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FuncionarioPontosScreen(usuarioId: usuarioId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Pesquisar Funcionários',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar Nome',
                labelStyle: TextStyle(color: Colors.black),
              ),
              onChanged:
                  _searchFuncionarios, // Filtra os funcionários ao digitar
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFuncionarios.length,
              itemBuilder: (context, index) {
                var funcionario = _filteredFuncionarios[index];
                return ListTile(
                  title: Text(funcionario.nome),
                  subtitle: Text('Visualizar o Ponto!'), // Exemplo de ponto
                  onTap: () => _openFuncionarioPontosScreen(funcionario.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
