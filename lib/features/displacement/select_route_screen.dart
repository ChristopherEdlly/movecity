import 'package:flutter/material.dart';
import '../../core/mock/banco_mock.dart';
import '../../core/widgets/barra_navegacao.dart';

class SelectRouteScreen extends StatefulWidget {
  const SelectRouteScreen({super.key});

  @override
  State<SelectRouteScreen> createState() => _SelectRouteScreenState();
}

class _SelectRouteScreenState extends State<SelectRouteScreen> {
  static const Color _verde = Color(0xFF1D9E75);
  static const Color _fundo = Color(0xFFF3F3F2);

  final TextEditingController _buscaController = TextEditingController();
  int _indiceRotaSelecionada = 0;
  String _termoBusca = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<_RotaIndexada> get _rotasFiltradas {
    if (_termoBusca.trim().isEmpty) {
      return [
        for (var i = 0; i < BancoMock.rotas.length; i++)
          _RotaIndexada(index: i, rota: BancoMock.rotas[i]),
      ];
    }
    final termo = _termoBusca.toLowerCase();
    return [
      for (var i = 0; i < BancoMock.rotas.length; i++)
        if (BancoMock.rotas[i].nome.toLowerCase().contains(termo))
          _RotaIndexada(index: i, rota: BancoMock.rotas[i]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final rotasFiltradas = _rotasFiltradas;

    return Scaffold(
      backgroundColor: _fundo,
      bottomNavigationBar: const BarraNavegacao(indiceSelecionado: 1),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildCabecalho(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
                children: [
                  _buildIndicadorPassos(),
                  const SizedBox(height: 20),
                  _buildCampoBusca(),
                  const SizedBox(height: 22),
                  const Text(
                    'Suas rotas',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF202221)),
                  ),
                  const SizedBox(height: 12),
                  if (rotasFiltradas.isEmpty)
                    _buildEstadoVazio()
                  else
                    ...rotasFiltradas.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CartaoRota(
                          rota: item.rota,
                          selecionado: item.index == _indiceRotaSelecionada,
                          aoTocar: () => setState(() => _indiceRotaSelecionada = item.index),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _verde,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: _verde.withValues(alpha: 0.28),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Confirmar rota', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCabecalho(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, MediaQuery.of(context).padding.top + 8, 20, 24),
      decoration: const BoxDecoration(
        color: _verde,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Iniciar deslocamento',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Qual rota você vai usar?',
                    style: TextStyle(fontSize: 14, color: Color(0xFFC7F0DF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicadorPassos() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: const Row(
        children: [
          _IndicadorPasso(numero: '1', label: 'Rota', ativo: true),
          Expanded(child: _DivisorPasso()),
          _IndicadorPasso(numero: '2', label: 'Saída'),
          Expanded(child: _DivisorPasso()),
          _IndicadorPasso(numero: '3', label: 'Chegada'),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE6E6E3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _verde, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildEstadoVazio() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6E3)),
      ),
      child: const Center(
        child: Text(
          'Nenhuma rota encontrada',
          style: TextStyle(color: Color(0xFF777777), fontSize: 13),
        ),
      ),
    );
  }
}

class _CartaoRota extends StatelessWidget {
  final DadosRota rota;
  final bool selecionado;
  final VoidCallback aoTocar;

  const _CartaoRota({
    required this.rota,
    required this.selecionado,
    required this.aoTocar,
  });

  static const Color _verde = Color(0xFF1D9E75);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selecionado ? _verde : const Color(0xFFEAEAE7),
              width: selecionado ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
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
                    Text(
                      rota.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202221),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${rota.transporte} · ~${rota.tempoEstimadoMin} min',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A7A)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${rota.usos} usos',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF777777),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 9),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: selecionado ? _verde : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selecionado ? _verde : const Color(0xFFC9C9C9),
                        width: 1.5,
                      ),
                    ),
                    child: selecionado
                        ? const Icon(Icons.check, size: 15, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndicadorPasso extends StatelessWidget {
  final String numero;
  final String label;
  final bool ativo;

  const _IndicadorPasso({required this.numero, required this.label, this.ativo = false});

  static const Color _verde = Color(0xFF1D9E75);

  @override
  Widget build(BuildContext context) {
    final cor = ativo ? _verde : const Color(0xFFB5B5B5);

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ativo ? _verde : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: cor, width: 1.5),
          ),
          child: Text(
            numero,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: ativo ? Colors.white : cor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
            color: cor,
          ),
        ),
      ],
    );
  }
}

class _DivisorPasso extends StatelessWidget {
  const _DivisorPasso();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 22),
      color: const Color(0xFFD8D8D6),
    );
  }
}

class _RotaIndexada {
  final int index;
  final DadosRota rota;

  const _RotaIndexada({required this.index, required this.rota});
}
