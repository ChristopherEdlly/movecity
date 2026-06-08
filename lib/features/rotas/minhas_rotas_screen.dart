import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/mock/banco_mock.dart';
import '../../core/repositories/deslocamento_repositorio.dart';
import '../../core/repositories/rota_repositorio.dart';
import '../../core/widgets/barra_navegacao.dart';
import 'editar_rota_screen.dart';
import 'criar_rota_screen.dart';

class MinhasRotasScreen extends StatefulWidget {
  const MinhasRotasScreen({super.key});

  @override
  State<MinhasRotasScreen> createState() => _MinhasRotasScreenState();
}

class _MinhasRotasScreenState extends State<MinhasRotasScreen> {
  final TextEditingController _buscaController = TextEditingController();
  String _termoBusca = '';

  List<Rota> _rotas = [];
  List<Deslocamento> _deslocamentos = [];
  bool _carregando = true;

  StreamSubscription<List<Rota>>? _assinaturaRotas;
  StreamSubscription<List<Deslocamento>>? _assinaturaDeslocamentos;

  @override
  void initState() {
    super.initState();
    _ouvirRotas();
  }

  void _ouvirRotas() {
    _assinaturaRotas = RotaRepositorio.buscarRotas(BancoMock.usuarioLogado.id).listen(
      (rotas) {
        if (!mounted) return;
        setState(() {
          _rotas = rotas;
          _carregando = false;
        });
        _ouvirDeslocamentos(rotas.map((r) => r.id).toList());
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _carregando = false);
      },
    );
  }

  void _ouvirDeslocamentos(List<int> rotaIds) {
    _assinaturaDeslocamentos?.cancel();
    if (rotaIds.isEmpty) {
      setState(() => _deslocamentos = []);
      return;
    }
    _assinaturaDeslocamentos = DeslocamentoRepositorio.buscarDeslocamentosDoUsuario(rotaIds).listen(
      (deslocamentos) {
        if (!mounted) return;
        setState(() => _deslocamentos = deslocamentos);
      },
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _assinaturaRotas?.cancel();
    _assinaturaDeslocamentos?.cancel();
    super.dispose();
  }

  int _usosDaRota(int rotaId) {
    return _deslocamentos.where((d) => d.rotaId == rotaId).length;
  }

  String _ultimoUsoDaRota(int rotaId) {
    final lista = _deslocamentos.where((d) => d.rotaId == rotaId).toList();
    if (lista.isEmpty) return '—';
    return lista.last.data;
  }

  List<Rota> get _rotasFiltradas {
    if (_termoBusca.trim().isEmpty) return _rotas;
    final termo = _termoBusca.toLowerCase();
    return _rotas.where((r) => r.nome.toLowerCase().contains(termo)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F3F2),
        bottomNavigationBar: BarraNavegacao(indiceSelecionado: 2),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1D9E75)),
        ),
      );
    }

    final rotas = _rotasFiltradas;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F2),
      bottomNavigationBar: const BarraNavegacao(indiceSelecionado: 2),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCabecalho(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCampoBusca(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: rotas.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma rota encontrada.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: rotas.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _buildCartaoRota(rotas[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CriarRotaScreen()),
              );
            },
            child: const Text(
              'Nova rota',
              style: TextStyle(color: Color(0xFF1D9E75), fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CriarRotaScreen()),
              );
            },
            backgroundColor: const Color(0xFF1D9E75),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCabecalho() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1D9E75),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Minhas rotas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            '${_rotas.length} rotas cadastradas',
            style: const TextStyle(fontSize: 13, color: Color(0xFFC7F0DF)),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoBusca() {
    return TextField(
      controller: _buscaController,
      onChanged: (value) => setState(() => _termoBusca = value),
      decoration: InputDecoration(
        hintText: 'Buscar rota...',
        hintStyle: const TextStyle(color: Color(0xFF9D9D9D), fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF8A8A8A)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE6E6E3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 1.4),
        ),
      ),
    );
  }

  Widget _buildCartaoRota(Rota rota) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditarRotaScreen(rota: rota)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: rota.cor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rota.nome, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    '${rota.transporte} · ~${rota.tempoEstimadoMin} min',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F3DE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_usosDaRota(rota.id)}×',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3B6D11)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(_ultimoUsoDaRota(rota.id), style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
