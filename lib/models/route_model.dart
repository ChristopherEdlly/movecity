class RouteModel {
  final int? id;
  final String nome;
  final String origem;
  final String destino;
  final String transporte;
  final int tempoEstimado;

  RouteModel({
    this.id,
    required this.nome,
    required this.origem,
    required this.destino,
    required this.transporte,
    required this.tempoEstimado,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'origem': origem,
      'destino': destino,
      'transporte': transporte,
      'tempo_estimado': tempoEstimado,
    };
  }

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      origem: map['origem'] as String,
      destino: map['destino'] as String,
      transporte: map['transporte'] as String,
      tempoEstimado: map['tempo_estimado'] as int,
    );
  }

  RouteModel copyWith({
    int? id,
    String? nome,
    String? origem,
    String? destino,
    String? transporte,
    int? tempoEstimado,
  }) {
    return RouteModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      origem: origem ?? this.origem,
      destino: destino ?? this.destino,
      transporte: transporte ?? this.transporte,
      tempoEstimado: tempoEstimado ?? this.tempoEstimado,
    );
  }

  @override
  String toString() {
    return 'RouteModel(id: $id, nome: $nome, origem: $origem, '
        'destino: $destino, transporte: $transporte, '
        'tempoEstimado: $tempoEstimado)';
  }
}
