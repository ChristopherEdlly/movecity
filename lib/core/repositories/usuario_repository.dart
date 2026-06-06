import 'package:cloud_firestore/cloud_firestore.dart';
import '../mock/banco_mock.dart';

class UsuarioRepository {
  static final _colecao = FirebaseFirestore.instance.collection('usuarios');

  static Future<void> salvar(Usuario usuario) async {
    await _colecao.doc(usuario.id.toString()).set(usuario.toMap());
  }

  static Future<Usuario?> buscarPorId(int id) async {
    final doc = await _colecao.doc(id.toString()).get();
    if (!doc.exists) return null;
    return Usuario.fromMap(doc.data()!);
  }
}
