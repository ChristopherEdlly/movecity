import '../mock/banco_mock.dart';
import '../repositories/usuario_repository.dart';
import '../repositories/rota_repository.dart';
import '../repositories/deslocamento_repository.dart';

// Popula o Firestore com os dados do BancoMock.
// Chamar apenas uma vez, em ambiente de desenvolvimento.
// Exemplo de uso no main.dart:
//   await SeedFirestore.popular();
class SeedFirestore {
  static Future<void> popular() async {
    await UsuarioRepository.salvar(BancoMock.usuarioLogado);

    for (final rota in BancoMock.rotas) {
      await RotaRepository.salvar(rota);
    }

    for (final deslocamento in BancoMock.deslocamentos) {
      await DeslocamentoRepository.salvar(deslocamento);
    }
  }
}
