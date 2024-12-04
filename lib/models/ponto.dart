import 'package:cloud_firestore/cloud_firestore.dart';

class Ponto {
  final String id;
  final String usuarioId;
  final DateTime entrada;
  final DateTime? saida;

  Ponto({
    required this.id,
    required this.usuarioId,
    required this.entrada,
    this.saida,
  });

  // Método para converter de JSON para Ponto
  factory Ponto.fromJson(Map<String, dynamic> json, String id) {
    return Ponto(
      id: id,
      usuarioId: json['usuarioId'],
      // Converte o Timestamp para DateTime
      entrada: (json['entrada'] as Timestamp).toDate(),
      // Verifica se 'saida' existe e converte para DateTime, se não, deixa como null
      saida:
          json['saida'] != null ? (json['saida'] as Timestamp).toDate() : null,
    );
  }

  // Método para converter de Ponto para JSON
  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      // Enviar o DateTime como Timestamp para o Firestore
      'entrada': Timestamp.fromDate(entrada),
      'saida': saida != null
          ? Timestamp.fromDate(saida!)
          : null, // Somente se saida não for null
    };
  }
}
