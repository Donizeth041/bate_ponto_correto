import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoricoScreen extends StatefulWidget {
  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  String tipoUsuario = ''; // Vai armazenar o tipo de usuário

  // Função para verificar o tipo de usuário
  Future<void> verificarTipoUsuario() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      setState(() {
        tipoUsuario = userDoc['tipo']; // 'admin' ou 'funcionario'
      });
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
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pontos')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Nenhum ponto registrado.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var ponto = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text('Entrada: ${ponto['data_ponto']}'),
                          subtitle: Text('Status: ${ponto['status']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pontos')
                                  .doc(ponto.id)
                                  .delete();
                            },
                          ),
                        );
                      },
                    );
                  },
                )
              : // Exibe apenas os pontos do usuário logado para o funcionário
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pontos')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Nenhum ponto registrado.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var ponto = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text('Entrada: ${ponto['data_ponto']}'),
                          subtitle: Text('Status: ${ponto['status']}'),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
