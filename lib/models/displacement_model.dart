class DisplacementModel {
  final int? id;
  final int routeId;
  final DateTime dataHoraSaida;
  final DateTime? dataHoraChegada;
  final int? duracao;
  final String? observacao;

  DisplacementModel({
    this.id,
    required this.routeId,
    required this.dataHoraSaida,
    this.dataHoraChegada,
    this.duracao,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'route_id': routeId,
      'data_hora_saida': dataHoraSaida.toIso8601String(),
      'data_hora_chegada': dataHoraChegada?.toIso8601String(),
      'duracao': duracao,
      'observacao': observacao,
    };
  }

  factory DisplacementModel.fromMap(Map<String, dynamic> map) {
    return DisplacementModel(
      id: map['id'] as int?,
      routeId: map['route_id'] as int,
      dataHoraSaida: DateTime.parse(map['data_hora_saida'] as String),
      dataHoraChegada: map['data_hora_chegada'] != null
          ? DateTime.parse(map['data_hora_chegada'] as String)
          : null,
      duracao: map['duracao'] as int?,
      observacao: map['observacao'] as String?,
    );
  }

  DisplacementModel copyWith({
    int? id,
    int? routeId,
    DateTime? dataHoraSaida,
    DateTime? dataHoraChegada,
    int? duracao,
    String? observacao,
  }) {
    return DisplacementModel(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      dataHoraSaida: dataHoraSaida ?? this.dataHoraSaida,
      dataHoraChegada: dataHoraChegada ?? this.dataHoraChegada,
      duracao: duracao ?? this.duracao,
      observacao: observacao ?? this.observacao,
    );
  }

  @override
  String toString() {
    return 'DisplacementModel(id: $id, routeId: $routeId, '
        'dataHoraSaida: $dataHoraSaida, dataHoraChegada: $dataHoraChegada, '
        'duracao: $duracao, observacao: $observacao)';
  }
}
