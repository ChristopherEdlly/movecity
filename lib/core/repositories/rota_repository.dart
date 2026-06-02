import 'package:cloud_firestore/cloud_firestore.dart';
import '../mock/banco_mock.dart';

class RotaRepository {
  static final _colecao = FirebaseFirestore.instance.collection('rotas');

  static Future<void> salvar(Rota rota) async {
    await _colecao.doc(rota.id.toString()).set(rota.toMap());
  }

  static Future<void> excluir(int id) async {
    await _colecao.doc(id.toString()).delete();
  }

  static Future<Rota?> buscarPorId(int id) async {
    final doc = await _colecao.doc(id.toString()).get();
    if (!doc.exists) return null;
    return Rota.fromMap(doc.data()!);
  }

  // Retorna as rotas do usuário em tempo real (atualiza a tela automaticamente)
  static Stream<List<Rota>> listarDoUsuario(int usuarioId) {
    return _colecao
        .where('usuarioId', isEqualTo: usuarioId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Rota.fromMap(doc.data())).toList());
  }
}
