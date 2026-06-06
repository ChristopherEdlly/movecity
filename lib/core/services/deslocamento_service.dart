import 'dart:async';

import '../mock/banco_mock.dart';

class DeslocamentoService {
  DeslocamentoService._internal() {
    _controller.add(List<Deslocamento>.unmodifiable(BancoMock.deslocamentos));
  }

  static final DeslocamentoService _instance = DeslocamentoService._internal();

  final StreamController<List<Deslocamento>> _controller =
      StreamController<List<Deslocamento>>.broadcast();

  factory DeslocamentoService() => _instance;

  Stream<List<Deslocamento>> listarDeslocamentos() => _controller.stream;

  Future<void> atualizarDeslocamento(Deslocamento deslocamento) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = BancoMock.deslocamentos.indexWhere((d) => d.id == deslocamento.id);
    if (index == -1) {
      throw Exception('Deslocamento não encontrado');
    }

    BancoMock.deslocamentos[index] = deslocamento;
    _controller.add(List<Deslocamento>.unmodifiable(BancoMock.deslocamentos));
  }

  Future<void> excluirDeslocamento(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    BancoMock.deslocamentos.removeWhere((d) => d.id == id);
    _controller.add(List<Deslocamento>.unmodifiable(BancoMock.deslocamentos));
  }
}
