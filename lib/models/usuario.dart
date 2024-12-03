class Usuario {
  final String id;
  final String nome;
  final String email;
  final String tipo; // Administrador ou Funcionário

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
  });

  // Método para converter de JSON para Usuario
  factory Usuario.fromJson(Map<String, dynamic> json, String id) {
    return Usuario(
      id: id,
      nome: json['nome'],
      email: json['email'],
      tipo: json['tipo'],
    );
  }

  // Método para converter de Usuario para JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'tipo': tipo,
    };
  }
}
