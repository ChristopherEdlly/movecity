import 'package:flutter/material.dart';

// Simulação do banco de dados enquanto o backend não está integrado.
// Todas as telas buscam dados daqui.
//
// DER:  Usuario 1 ──── N  Rota 1 ──── N  Deslocamento

class Usuario {
  final int id;
  final String nome;
  final String email;
  final String senha;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });
}

class Rota {
  final int id;
  final int usuarioId;
  final String nome;
  final String origem;
  final String destino;
  final int tempoEstimadoMin;
  final String transporte;
  final Color cor;
  final String? observacoes;

  const Rota({
    required this.id,
    required this.usuarioId,
    required this.nome,
    required this.origem,
    required this.destino,
    required this.tempoEstimadoMin,
    required this.transporte,
    required this.cor,
    this.observacoes,
  });
}

class Deslocamento {
  final int id;
  final int rotaId;
  final String data;
  final String horarioSaida;
  final String horarioChegada;
  final String transporte;
  final String observacao;

  const Deslocamento({
    required this.id,
    required this.rotaId,
    required this.data,
    required this.horarioSaida,
    required this.horarioChegada,
    required this.transporte,
    this.observacao = '',
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

class BancoMock {
  // ─── Usuário logado ────────────────────────────────────────────

  static const Usuario usuarioLogado = Usuario(
    id: 1,
    nome: 'Chris',
    email: 'chris@email.com',
    senha: '123456',
  );

  // ─── Rotas cadastradas ─────────────────────────────────────────

  static final List<Rota> rotas = [
    const Rota(
      id: 1,
      usuarioId: 1,
      nome: 'Casa → IFS',
      origem: 'Rua das Flores, 10 — Aracaju',
      destino: 'IFS Aracaju — Av. Eng. Gentil Tavares',
      tempoEstimadoMin: 35,
      transporte: 'Ônibus',
      cor: Color(0xFF1D9E75),
      observacoes: 'Ponto de ônibus na esquina',
    ),
    const Rota(
      id: 2,
      usuarioId: 1,
      nome: 'IFS → Trabalho',
      origem: 'IFS Aracaju — Av. Eng. Gentil Tavares',
      destino: 'Centro Empresarial — Aracaju',
      tempoEstimadoMin: 12,
      transporte: 'A pé',
      cor: Color(0xFFBA7517),
    ),
    const Rota(
      id: 3,
      usuarioId: 1,
      nome: 'Casa → Shopping Jardins',
      origem: 'Rua das Flores, 10 — Aracaju',
      destino: 'Shopping Jardins — Aracaju',
      tempoEstimadoMin: 20,
      transporte: 'Carro',
      cor: Color(0xFF9E9E9E),
    ),
    const Rota(
      id: 4,
      usuarioId: 1,
      nome: 'Trabalho → Academia',
      origem: 'Centro Empresarial — Aracaju',
      destino: 'Academia SmartFit — Aracaju',
      tempoEstimadoMin: 8,
      transporte: 'A pé',
      cor: Color(0xFF1D9E75),
    ),
  ];

  // ─── Deslocamentos registrados ─────────────────────────────────

  static final List<Deslocamento> deslocamentos = [
    const Deslocamento(
      id: 1,
      rotaId: 1,
      data: 'Hoje',
      horarioSaida: '07:42',
      horarioChegada: '08:19',
      transporte: 'Ônibus',
      observacao: 'Ônibus atrasado ~5 min na parada',
    ),
    const Deslocamento(
      id: 2,
      rotaId: 2,
      data: 'Hoje',
      horarioSaida: '13:10',
      horarioChegada: '13:24',
      transporte: 'A pé',
    ),
    const Deslocamento(
      id: 3,
      rotaId: 1,
      data: 'Ontem',
      horarioSaida: '07:55',
      horarioChegada: '08:43',
      transporte: 'Ônibus',
      observacao: 'Trânsito pesado na Av. Tancredo',
    ),
    const Deslocamento(
      id: 4,
      rotaId: 2,
      data: 'Ontem',
      horarioSaida: '13:20',
      horarioChegada: '13:32',
      transporte: 'A pé',
    ),
    const Deslocamento(
      id: 5,
      rotaId: 3,
      data: '27/03',
      horarioSaida: '18:00',
      horarioChegada: '18:22',
      transporte: 'Carro',
    ),
  ];

  // ─── Métodos computados — Rota ─────────────────────────────────

  static Rota rotaPorId(int id) => rotas.firstWhere((r) => r.id == id);

  static List<Deslocamento> deslocamentosDaRota(int rotaId) =>
      deslocamentos.where((d) => d.rotaId == rotaId).toList();

  static int usosDaRota(int rotaId) => deslocamentosDaRota(rotaId).length;

  static String ultimoUsoDaRota(int rotaId) {
    final lista = deslocamentosDaRota(rotaId);
    if (lista.isEmpty) return '—';
    return lista.last.data;
  }

  static String duracaoDeslocamento(Deslocamento d) {
    final partesSaida = d.horarioSaida.split(':');
    final partesChegada = d.horarioChegada.split(':');
    final saidaMin = int.parse(partesSaida[0]) * 60 + int.parse(partesSaida[1]);
    final chegadaMin = int.parse(partesChegada[0]) * 60 + int.parse(partesChegada[1]);
    final diferenca = chegadaMin - saidaMin;
    final total = diferenca < 0 ? diferenca + 24 * 60 : diferenca;
    if (total < 60) return '$total min';
    final h = total ~/ 60;
    final m = total % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  // ─── Métodos computados — Home ─────────────────────────────────

  static int get totalDeslocamentosHoje =>
      deslocamentos.where((d) => d.data == 'Hoje').length;

  static String get tempoTotalHojeFormatado {
    final deHoje = deslocamentos.where((d) => d.data == 'Hoje').toList();
    if (deHoje.isEmpty) return '0 min';
    int totalMin = 0;
    for (final d in deHoje) {
      final partesSaida = d.horarioSaida.split(':');
      final partesChegada = d.horarioChegada.split(':');
      final saidaMin = int.parse(partesSaida[0]) * 60 + int.parse(partesSaida[1]);
      final chegadaMin = int.parse(partesChegada[0]) * 60 + int.parse(partesChegada[1]);
      final diferenca = chegadaMin - saidaMin;
      totalMin += diferenca < 0 ? diferenca + 24 * 60 : diferenca;
    }
    if (totalMin < 60) return '$totalMin min';
    final h = totalMin ~/ 60;
    final m = totalMin % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  static int get diaAtualIndex => (DateTime.now().weekday - 1) % 7;

  static List<int> get graficoSemana {
    final hoje = DateTime.now();
    final contagem = List<int>.filled(7, 0);
    for (final d in deslocamentos) {
      int? diaIndex;
      if (d.data == 'Hoje') {
        diaIndex = (hoje.weekday - 1) % 7;
      } else if (d.data == 'Ontem') {
        diaIndex = (hoje.subtract(const Duration(days: 1)).weekday - 1) % 7;
      }
      if (diaIndex != null) contagem[diaIndex]++;
    }
    return contagem;
  }

  // ─── Mock específico da Home ───────────────────────────────────
  // Em produção, sugestão e alerta viriam de algoritmos e APIs externas.
  // Para testar os estados da home, altere os valores abaixo:
  //   sugestaoAtual = null  →  estado normal
  //   rotas = []            →  estado novo usuário

  static SugestaoRota? sugestaoAtual = SugestaoRota(
    rota: 'Casa → IFS',
    transporte: 'Ônibus',
    tempoEstimado: '~35 min',
    saidaIdeal: '07:20',
  );

  static AlertaTransito? alertaAtual = AlertaTransito(
    titulo: 'Trânsito elevado na Tancredo Neves',
    mensagem: 'Considere sair 10 min mais cedo hoje.',
  );

  static String? dicaAtual =
      'Dica: às quartas, a Av. Tancredo Neves costuma ter +12 min de trânsito.';
}
