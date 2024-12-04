import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bateponto/models/usuario.dart';

class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Coleção de usuários no Firestore
  CollectionReference get usuariosCollection =>
      _firestore.collection('usuarios');

  // Método para obter todos os usuários
  Future<List<Usuario>> getUsuarios() async {
    try {
      final snapshot = await usuariosCollection.get();
      return snapshot.docs.map((doc) {
        return Usuario.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao carregar usuários: $e');
    }
  }

  // Método para obter um usuário pelo ID
  Future<Usuario> getUsuarioById(String id) async {
    try {
      final docSnapshot = await usuariosCollection.doc(id).get();
      if (docSnapshot.exists) {
        return Usuario.fromJson(docSnapshot.data() as Map<String, dynamic>, id);
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao carregar o usuário: $e');
    }
  }

  // Método para criar um novo usuário
  Future<void> createUsuario(Usuario usuario) async {
    try {
      await usuariosCollection.doc(usuario.id).set(usuario.toJson());
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  // Método para atualizar um usuário
  Future<void> updateUsuario(Usuario usuario) async {
    try {
      await usuariosCollection.doc(usuario.id).update(usuario.toJson());
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  // Método para deletar um usuário
  Future<void> deleteUsuario(String id) async {
    try {
      await usuariosCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar usuário: $e');
    }
  }
}
