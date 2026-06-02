import 'package:cloud_firestore/cloud_firestore.dart';
import '../mock/banco_mock.dart';

// Repositório de Deslocamentos — faz a ponte entre o app e o Firestore.
// Enquanto o banco não estiver populado, as telas continuam usando BancoMock.
// Quando estiver pronto, basta trocar BancoMock.deslocamentos por DeslocamentoRepositorio.buscarDeslocamentos().

class DeslocamentoRepositorio {
  static final _db = FirebaseFirestore.instance;
  static const _colecao = 'deslocamentos';

  // ─── Conversão ────────────────────────────────────────────────

  static Map<String, dynamic> _paraMapa(Deslocamento d) {
    return {
      'rotaId': d.rotaId,
      'data': d.data,
      'horarioSaida': d.horarioSaida,
      'horarioChegada': d.horarioChegada,
      'transporte': d.transporte,
      'observacao': d.observacao,
    };
  }

  static Deslocamento _deMapa(Map<String, dynamic> mapa, String docId) {
    return Deslocamento(
      id: int.tryParse(docId) ?? 0,
      rotaId: (mapa['rotaId'] as num).toInt(),
      data: mapa['data'] ?? '',
      horarioSaida: mapa['horarioSaida'] ?? '',
      horarioChegada: mapa['horarioChegada'] ?? '',
      transporte: mapa['transporte'] ?? '',
      observacao: mapa['observacao'] ?? '',
    );
  }

  // ─── Leitura ──────────────────────────────────────────────────

  // Retorna uma stream que atualiza automaticamente quando o Firestore mudar.
  static Stream<List<Deslocamento>> buscarDeslocamentos(int rotaId) {
    return _db
        .collection(_colecao)
        .where('rotaId', isEqualTo: rotaId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => _deMapa(doc.data(), doc.id)).toList());
  }

  // Busca todos os deslocamentos de um usuário (via lista de rotaIds).
  static Stream<List<Deslocamento>> buscarDeslocamentosDoUsuario(List<int> rotaIds) {
    if (rotaIds.isEmpty) return Stream.value([]);
    return _db
        .collection(_colecao)
        .where('rotaId', whereIn: rotaIds)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => _deMapa(doc.data(), doc.id)).toList());
  }

  // ─── Escrita ──────────────────────────────────────────────────

  static Future<void> salvar(Deslocamento d) async {
    await _db
        .collection(_colecao)
        .doc(d.id.toString())
        .set(_paraMapa(d));
  }

  static Future<void> excluir(int deslocamentoId) async {
    await _db.collection(_colecao).doc(deslocamentoId.toString()).delete();
  }
}
