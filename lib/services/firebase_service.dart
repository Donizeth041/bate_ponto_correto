import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';
import '../models/ponto.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CRUD para Usuários
  Future<void> criarUsuario(Usuario usuario) async {
    await _firestore
        .collection('usuarios')
        .doc(usuario.id)
        .set(usuario.toJson());
  }

  Future<Usuario?> buscarUsuario(String id) async {
    final doc = await _firestore.collection('usuarios').doc(id).get();
    if (doc.exists) {
      return Usuario.fromJson(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    await _firestore
        .collection('usuarios')
        .doc(usuario.id)
        .update(usuario.toJson());
  }

  Future<void> deletarUsuario(String id) async {
    await _firestore.collection('usuarios').doc(id).delete();
  }

  // CRUD para Pontos
  Future<void> criarPonto(Ponto ponto) async {
    await _firestore.collection('pontos').doc(ponto.id).set(ponto.toJson());
  }

  Future<List<Ponto>> listarPontos(String usuarioId) async {
    final query = await _firestore
        .collection('pontos')
        .where('usuarioId', isEqualTo: usuarioId)
        .get();

    return query.docs.map((doc) => Ponto.fromJson(doc.data(), doc.id)).toList();
  }

  Future<void> atualizarPonto(Ponto ponto) async {
    await _firestore.collection('pontos').doc(ponto.id).update(ponto.toJson());
  }

  Future<void> deletarPonto(String id) async {
    await _firestore.collection('pontos').doc(id).delete();
  }
}
