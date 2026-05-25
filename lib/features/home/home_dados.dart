// Estrutura de dados que o backend provavelmente retornará.

class DadosHome {
  final String nomeUsuario;
  final int deslocamentosHoje;
  final String tempoTotalHoje;
  final SugestaoRota? sugestao;
  final AlertaTransito? alertaTransito;
  final List<int> graficoSemana;
  final int diaAtualIndex;
  final String? dica;

  DadosHome({
    required this.nomeUsuario,
    required this.deslocamentosHoje,
    required this.tempoTotalHoje,
    this.sugestao,
    this.alertaTransito,
    required this.graficoSemana,
    required this.diaAtualIndex,
    this.dica,
  });
}

class SugestaoRota {
  final String rota;
  final String transporte;
  final String tempoEstimado;
  final String saidaIdeal;

  SugestaoRota({
    required this.rota,
    required this.transporte,
    required this.tempoEstimado,
    required this.saidaIdeal,
  });
}

class AlertaTransito {
  final String titulo;
  final String mensagem;

  AlertaTransito({required this.titulo, required this.mensagem});
}
