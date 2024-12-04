import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bateponto/models/ponto.dart';

class PontoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Coleção de pontos no Firestore
  CollectionReference get pontosCollection => _firestore.collection('pontos');

  // Método para obter todos os pontos de um usuário
  Future<List<Ponto>> getPontosByUsuario(String usuarioId) async {
    try {
      final snapshot =
          await pontosCollection.where('usuarioId', isEqualTo: usuarioId).get();

      return snapshot.docs.map((doc) {
        return Ponto.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao carregar os pontos: $e');
    }
  }

  Future<List<Ponto>> getAllPontos() async {
    try {
      // Realiza a consulta para buscar todos os pontos na coleção "pontos"
      final snapshot = await pontosCollection.get();

      // Mapeia os documentos retornados para objetos do tipo Ponto
      return snapshot.docs.map((doc) {
        return Ponto.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao carregar todos os pontos: $e');
    }
  }

  // Método para obter um ponto específico pelo ID
  Future<Ponto> getPontoById(String id) async {
    try {
      final docSnapshot = await pontosCollection.doc(id).get();
      if (docSnapshot.exists) {
        return Ponto.fromJson(docSnapshot.data() as Map<String, dynamic>, id);
      } else {
        throw Exception('Ponto não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao carregar o ponto: $e');
    }
  }

  // Método para criar um novo ponto
  Future<void> createPonto(Ponto ponto) async {
    try {
      await pontosCollection.add(ponto.toJson());
    } catch (e) {
      throw Exception('Erro ao criar ponto: $e');
    }
  }

  // Método para atualizar o ponto (atualizando a hora de saída)
  Future<void> updatePonto(Ponto ponto) async {
    try {
      await pontosCollection.doc(ponto.id).update(ponto.toJson());
    } catch (e) {
      throw Exception('Erro ao atualizar ponto: $e');
    }
  }

  // Método para deletar um ponto
  Future<void> deletePonto(String id) async {
    try {
      await pontosCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar ponto: $e');
    }
  }

  Future<void> registrarPonto(String usuarioId, bool aberto) async {
    try {
      // Referência da coleção 'pontos'
      CollectionReference pontos = _firestore.collection('pontos');

      // Se o ponto estiver aberto, cria um novo ponto com a data de entrada
      if (aberto) {
        await pontos.add({
          'usuarioId': usuarioId,
          'entrada': Timestamp.now(), // Data e hora do ponto de entrada
          'saida': null, // A saída será nula inicialmente
        });
      }
      print('Ponto registrado com sucesso!');
    } catch (e) {
      print('Erro ao registrar o ponto: $e');
    }
  }

  // Função para fechar o ponto de saída
  Future<void> fecharPonto(String usuarioId) async {
    try {
      // Buscar o ponto aberto mais recente do usuário
      QuerySnapshot querySnapshot = await _firestore
          .collection('pontos')
          .where('usuarioId', isEqualTo: usuarioId)
          .where('saida', isEqualTo: null) // Somente os pontos abertos
          .orderBy('entrada', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot ponto = querySnapshot.docs.first;

        // Atualizar o ponto com a hora de saída
        await _firestore.collection('pontos').doc(ponto.id).update({
          'saida': Timestamp.now(),
        });

        print('Ponto fechado com sucesso!');
      } else {
        print('Nenhum ponto aberto encontrado.');
      }
    } catch (e) {
      print('Erro ao fechar o ponto: $e');
    }
  }

  Future<DocumentSnapshot?> getUltimoPonto(String usuarioId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('pontos')
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('entrada',
              descending: true) // Ordena pela entrada mais recente
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
      return null;
    } catch (e) {
      print('Erro ao buscar o último ponto: $e');
      return null;
    }
  }

  // Método para fechar o último ponto aberto
  Future<void> fecharUltimoPonto(String usuarioId) async {
    try {
      var ultimoPonto = await getUltimoPonto(usuarioId);
      if (ultimoPonto != null && ultimoPonto['saida'] == null) {
        await _firestore.collection('pontos').doc(ultimoPonto.id).update({
          'saida': Timestamp.now(), // Define a hora de saída
        });
      }
    } catch (e) {
      print('Erro ao fechar o último ponto: $e');
    }
  }

  // Função para verificar se o ponto foi aberto ou fechado
  Future<bool> verificarPontoAberto(String usuarioId) async {
    try {
      // Primeiro, verifica se o usuário tem algum ponto registrado
      QuerySnapshot pontosRegistradosSnapshot = await _firestore
          .collection('pontos')
          .where('usuarioId', isEqualTo: usuarioId)
          .get();

      // Se não houver pontos registrados, retorna false imediatamente
      if (pontosRegistradosSnapshot.docs.isEmpty) {
        return false; // Não há pontos registrados
      }

      // Caso tenha pontos registrados, agora verificamos se há ponto aberto
      QuerySnapshot querySnapshot = await _firestore
          .collection('pontos')
          .where('usuarioId', isEqualTo: usuarioId)
          .where('saida', isEqualTo: null) // Somente os pontos abertos
          .orderBy('entrada', descending: true)
          .limit(1)
          .get();

      // Retorna se há um ponto aberto (saida == null)
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar o ponto: $e');
      return false;
    }
  }
}
