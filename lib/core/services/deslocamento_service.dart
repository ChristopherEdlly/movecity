import '../mock/banco_mock.dart';
import '../repositories/deslocamento_repositorio.dart';

class DeslocamentoService {
  Stream<List<Deslocamento>> listarDeslocamentos() {
    final rotaIds = BancoMock.rotas.map((rota) => rota.id).toList();
    return DeslocamentoRepositorio.buscarDeslocamentosDoUsuario(rotaIds);
  }

  Future<void> atualizarDeslocamento(Deslocamento deslocamento) {
    return DeslocamentoRepositorio.salvar(deslocamento);
  }

  Future<void> excluirDeslocamento(String id) {
    final deslocamentoId = int.tryParse(id);
    if (deslocamentoId == null) {
      throw Exception('ID de deslocamento inválido');
    }
    return DeslocamentoRepositorio.excluir(deslocamentoId);
  }
}
