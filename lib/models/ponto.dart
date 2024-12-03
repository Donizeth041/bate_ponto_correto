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
      entrada: DateTime.parse(json['entrada']),
      saida: json['saida'] != null ? DateTime.parse(json['saida']) : null,
    );
  }

  // Método para converter de Ponto para JSON
  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'entrada': entrada.toIso8601String(),
      'saida': saida?.toIso8601String(),
    };
  }
}
