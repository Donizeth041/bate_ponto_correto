import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PesquisaScreen extends StatefulWidget {
  @override
  _PesquisaScreenState createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _funcionarios = [];

  // Função para buscar funcionários no Firestore
  void _searchFuncionarios(String nome) async {
    // Realiza a busca no Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('name', isGreaterThanOrEqualTo: nome)
        .where('name', isLessThan: nome + 'z')
        .get();

    setState(() {
      _funcionarios = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Pesquisar Pontos', style: TextStyle(color: Colors.black)),
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
              onChanged: _searchFuncionarios,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _funcionarios.length,
              itemBuilder: (context, index) {
                var funcionario = _funcionarios[index];
                return ListTile(
                  title: Text(funcionario['name']),
                  subtitle: Text(
                      'Último Ponto: 2024-10-01 17:00'), // Pode adicionar o timestamp do ponto aqui
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
