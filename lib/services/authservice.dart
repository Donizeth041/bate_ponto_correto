import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para criar um novo usuário com email e senha
  Future<UserCredential?> createUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(e);
      return null;
    }
  }

  // Método para fazer login com email e senha
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(e);
      return null;
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Método para obter o usuário atual
  User? get currentUser => _auth.currentUser;

  // Método para verificar se o usuário está autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  // Método para enviar email de verificação para o usuário
  Future<void> sendEmailVerification() async {
    final User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Método para redefinir a senha do usuário
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _showErrorMessage(e);
    }
  }

  // Método privado para mostrar mensagens de erro
  void _showErrorMessage(FirebaseAuthException e) {
    String errorMessage = '';
    if (e.code == 'email-already-in-use') {
      errorMessage = 'Este email já está em uso.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'O email fornecido é inválido.';
    } else if (e.code == 'weak-password') {
      errorMessage = 'A senha fornecida é muito fraca.';
    } else {
      errorMessage = e.message ?? 'Ocorreu um erro desconhecido.';
    }

    // Exibe um Snackbar ou um AlertDialog com a mensagem de erro
    print('Erro: $errorMessage');
    // Se preferir, pode exibir um Snackbar ou Dialog com a mensagem
  }
}
