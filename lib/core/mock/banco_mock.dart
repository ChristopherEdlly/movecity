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
  final String data;
  final String horarioSaida;
  final String horarioChegada;
  final String transporte;
  final String duracao;
  final Color cor;
  final String observacao;

  const EntradaHistorico({
    required this.titulo,
    required this.data,
    required this.horarioSaida,
    required this.horarioChegada,
    required this.transporte,
    required this.duracao,
    required this.cor,
    this.observacao = '',
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

  static final List<EntradaHistorico> historico = [
    const EntradaHistorico(
      titulo: 'Casa → IFS',
      data: 'Hoje',
      horarioSaida: '07:42',
      horarioChegada: '08:19',
      transporte: 'Ônibus',
      duracao: '37 min',
      cor: Color(0xFF1D9E75),
      observacao: 'Ônibus atrasado ~5 min na parada',
    ),
    const EntradaHistorico(
      titulo: 'IFS → Trabalho',
      data: 'Hoje',
      horarioSaida: '13:10',
      horarioChegada: '13:24',
      transporte: 'A pé',
      duracao: '14 min',
      cor: Color(0xFF1D9E75),
    ),
    const EntradaHistorico(
      titulo: 'Casa → IFS',
      data: 'Ontem',
      horarioSaida: '07:55',
      horarioChegada: '08:43',
      transporte: 'Ônibus',
      duracao: '48 min',
      cor: Color(0xFFF57C00),
      observacao: 'Trânsito pesado na Av. Tancredo',
    ),
    const EntradaHistorico(
      titulo: 'IFS → Trabalho',
      data: 'Ontem',
      horarioSaida: '13:20',
      horarioChegada: '13:32',
      transporte: 'A pé',
      duracao: '12 min',
      cor: Color(0xFF1D9E75),
    ),
    const EntradaHistorico(
      titulo: 'Casa → Shopping Jardins',
      data: '27/03',
      horarioSaida: '18:00',
      horarioChegada: '18:22',
      transporte: 'Carro',
      duracao: '22 min',
      cor: Color(0xFF1D9E75),
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
