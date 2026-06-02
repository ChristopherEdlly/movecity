import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../mock/banco_mock.dart';

// Repositório de Rotas — faz a ponte entre o app e o Firestore.
// Enquanto o banco não estiver populado, as telas continuam usando BancoMock.
// Quando estiver pronto, basta trocar BancoMock.rotas por RotaRepositorio.buscarRotas().

class RotaRepositorio {
  static final _db = FirebaseFirestore.instance;
  static const _colecao = 'rotas';

  // ─── Conversão ────────────────────────────────────────────────

  static Map<String, dynamic> _paraMapa(Rota rota) {
    return {
      'usuarioId': rota.usuarioId,
      'nome': rota.nome,
      'origem': rota.origem,
      'destino': rota.destino,
      'tempoEstimadoMin': rota.tempoEstimadoMin,
      'transporte': rota.transporte,
      'cor': rota.cor.toARGB32(),
      'observacoes': rota.observacoes,
    };
  }

  static Rota _deMapa(Map<String, dynamic> mapa, String docId) {
    return Rota(
      id: int.tryParse(docId) ?? 0,
      usuarioId: (mapa['usuarioId'] as num).toInt(),
      nome: mapa['nome'] ?? '',
      origem: mapa['origem'] ?? '',
      destino: mapa['destino'] ?? '',
      tempoEstimadoMin: (mapa['tempoEstimadoMin'] as num).toInt(),
      transporte: mapa['transporte'] ?? '',
      cor: Color((mapa['cor'] as num).toInt()),
      observacoes: mapa['observacoes'],
    );
  }

  // ─── Leitura ──────────────────────────────────────────────────

  // Retorna uma stream que atualiza automaticamente quando o Firestore mudar.
  static Stream<List<Rota>> buscarRotas(int usuarioId) {
    return _db
        .collection(_colecao)
        .where('usuarioId', isEqualTo: usuarioId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => _deMapa(doc.data(), doc.id)).toList());
  }

  // ─── Escrita ──────────────────────────────────────────────────

  static Future<void> salvar(Rota rota) async {
    await _db
        .collection(_colecao)
        .doc(rota.id.toString())
        .set(_paraMapa(rota));
  }

  static Future<void> excluir(int rotaId) async {
    await _db.collection(_colecao).doc(rotaId.toString()).delete();
  }
}
