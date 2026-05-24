import 'package:flutter/material.dart';

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

class RotasMockDados {
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
}
