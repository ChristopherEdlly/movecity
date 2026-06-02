import 'package:cloud_firestore/cloud_firestore.dart';
import '../mock/banco_mock.dart';

class DeslocamentoRepository {
  static final _colecao = FirebaseFirestore.instance.collection('deslocamentos');

  static Future<void> salvar(Deslocamento deslocamento) async {
    await _colecao.doc(deslocamento.id.toString()).set(deslocamento.toMap());
  }

  static Future<void> excluir(int id) async {
    await _colecao.doc(id.toString()).delete();
  }

  // Retorna todos os deslocamentos de uma rota específica em tempo real
  static Stream<List<Deslocamento>> listarDaRota(int rotaId) {
    return _colecao
        .where('rotaId', isEqualTo: rotaId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Deslocamento.fromMap(doc.data())).toList());
  }

  // Retorna todos os deslocamentos do usuário em tempo real (via rotas)
  static Stream<List<Deslocamento>> listarPorRotas(List<int> rotaIds) {
    if (rotaIds.isEmpty) return Stream.value([]);
    return _colecao
        .where('rotaId', whereIn: rotaIds)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Deslocamento.fromMap(doc.data())).toList());
  }
}
