import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importando o Firestore

class PontoScreen extends StatefulWidget {
  @override
  _PontoScreenState createState() => _PontoScreenState();
}

class _PontoScreenState extends State<PontoScreen> {
  bool pontoAberto = false;

  // Função para registrar o ponto no Firestore
  Future<void> registrarPonto(bool aberto) async {
    try {
      // Referência da coleção 'pontos'
      CollectionReference pontos =
          FirebaseFirestore.instance.collection('pontos');

      // Criando o documento com os dados
      await pontos.add({
        'data_ponto': Timestamp.now(), // Data e hora do ponto
        'status': aberto ? 'aberto' : 'fechado', // Status do ponto
      });
      print('Ponto registrado com sucesso!');
    } catch (e) {
      print('Erro ao registrar o ponto: $e');
    }
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
            pontoAberto
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pontoAberto = false;
                      });
                      // Registrar o fechamento do ponto
                      registrarPonto(false);
                    },
                    child: Text('Fechar Ponto',
                        style: TextStyle(color: Colors.white)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pontoAberto = true;
                      });
                      // Registrar a abertura do ponto
                      registrarPonto(true);
                    },
                    child: Text('Abrir Ponto',
                        style: TextStyle(color: Colors.white)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
          ],
        ),
      ),
    );
  }
}
