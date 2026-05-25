import 'package:flutter/material.dart';
import '../../features/home/home_dados.dart';

// Simulação do banco de dados enquanto o backend não está integrado.
// Todas as telas buscam dados daqui.

class DadosRota {
  final String nome;
  final String origem;
  final String destino;
  final int tempoEstimadoMin;
  final String transporte;
  final String? observacoes;
  final int usos;
  final String ultimoUso;
  final Color cor;

  DadosRota({
    required this.nome,
    required this.origem,
    required this.destino,
    required this.tempoEstimadoMin,
    required this.transporte,
    required this.usos,
    required this.ultimoUso,
    required this.cor,
    this.observacoes,
  });
}

class EntradaHistorico {
  final String titulo;
  final String subtitulo;
  final String duracao;
  final Color cor;
  final String observacao;

  const EntradaHistorico({
    required this.titulo,
    required this.subtitulo,
    required this.duracao,
    required this.cor,
    required this.observacao,
  });
}

class BancoMock {
  // ─── Rotas cadastradas ─────────────────────────────────────────

  static final List<DadosRota> rotas = [
    DadosRota(
      nome: 'Casa → IFS',
      origem: 'Rua das Flores, 10 — Aracaju',
      destino: 'IFS Aracaju — Av. Eng. Gentil Tavares',
      tempoEstimadoMin: 35,
      transporte: 'Ônibus',
      usos: 23,
      ultimoUso: 'Hoje',
      cor: const Color(0xFF1D9E75),
      observacoes: 'Ponto de ônibus na esquina',
    ),
    DadosRota(
      nome: 'IFS → Trabalho',
      origem: 'IFS Aracaju — Av. Eng. Gentil Tavares',
      destino: 'Centro Empresarial — Aracaju',
      tempoEstimadoMin: 12,
      transporte: 'A pé',
      usos: 18,
      ultimoUso: 'Ontem',
      cor: const Color(0xFFBA7517),
    ),
    DadosRota(
      nome: 'Casa → Shopping Jardins',
      origem: 'Rua das Flores, 10 — Aracaju',
      destino: 'Shopping Jardins — Aracaju',
      tempoEstimadoMin: 20,
      transporte: 'Carro',
      usos: 7,
      ultimoUso: 'Dom',
      cor: Colors.grey,
    ),
    DadosRota(
      nome: 'Trabalho → Academia',
      origem: 'Centro Empresarial — Aracaju',
      destino: 'Academia SmartFit — Aracaju',
      tempoEstimadoMin: 8,
      transporte: 'A pé',
      usos: 12,
      ultimoUso: 'Sex',
      cor: const Color(0xFF1D9E75),
    ),
  ];

  // ─── Histórico de deslocamentos ────────────────────────────────

  static const List<EntradaHistorico> historico = [
    EntradaHistorico(
      titulo: 'Casa → IFS',
      subtitulo: 'Hoje, 07:42',
      duracao: '37 min',
      cor: Color(0xFF1D9E75),
      observacao: '',
    ),
    EntradaHistorico(
      titulo: 'IFS → Trabalho',
      subtitulo: 'Hoje, 13:10',
      duracao: '14 min',
      cor: Color(0xFF1D9E75),
      observacao: '',
    ),
    EntradaHistorico(
      titulo: 'Casa → IFS',
      subtitulo: 'Ontem, 07:55',
      duracao: '48 min',
      cor: Color(0xFFF57C00),
      observacao: 'acima do normal',
    ),
    EntradaHistorico(
      titulo: 'IFS → Trabalho',
      subtitulo: 'Ontem, 13:20',
      duracao: '12 min',
      cor: Color(0xFF1D9E75),
      observacao: '',
    ),
    EntradaHistorico(
      titulo: 'Casa → Shopping Jardins',
      subtitulo: '27/03, 18:00',
      duracao: '22 min',
      cor: Color(0xFF1D9E75),
      observacao: '',
    ),
  ];

  // ─── Dados da home (simula retorno do backend) ─────────────────
  // Para testar, troque o _dados em home_screen.dart por:
  //   BancoMock.novoUsuario
  //   BancoMock.usuarioNormal
  //   BancoMock.usuarioComSugestao

  static final DadosHome novoUsuario = DadosHome(
    nomeUsuario: '',
    deslocamentosHoje: 0,
    tempoTotalHoje: '',
    graficoSemana: [],
    diaAtualIndex: 0,
  );

  static final DadosHome usuarioNormal = DadosHome(
    nomeUsuario: 'Chris',
    deslocamentosHoje: 2,
    tempoTotalHoje: '1h 14min',
    graficoSemana: [34, 27, 0, 44, 25, 0, 0],
    diaAtualIndex: 4,
    dica: 'Dica: às quartas, a Av. Tancredo Neves costuma ter +12 min de trânsito.',
  );

  static final DadosHome usuarioComSugestao = DadosHome(
    nomeUsuario: 'Lucas',
    deslocamentosHoje: 0,
    tempoTotalHoje: '— min',
    sugestao: SugestaoRota(
      rota: 'Casa → IFS',
      transporte: 'Ônibus',
      tempoEstimado: '~35 min',
      saidaIdeal: '07:20',
    ),
    alertaTransito: AlertaTransito(
      titulo: 'Trânsito elevado na Tancredo Neves',
      mensagem: 'Considere sair 10 min mais cedo hoje.',
    ),
    graficoSemana: [0, 0, 0, 0, 0, 0, 0],
    diaAtualIndex: 0,
  );
}
