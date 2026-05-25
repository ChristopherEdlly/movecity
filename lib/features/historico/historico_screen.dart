import 'package:flutter/material.dart';
import '../../core/mock/banco_mock.dart';
import '../../core/widgets/barra_navegacao.dart';
import 'editar_deslocamento_screen.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  String get _mesAno {
    final agora = DateTime.now();
    const meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    return '${meses[agora.month - 1]} de ${agora.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BarraNavegacao(indiceSelecionado: 3),
      body: Column(
        children: [
          _buildCabecalho(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildFiltroData(),
                  const SizedBox(height: 16),
                  _buildCartoesResumo(),
                  const SizedBox(height: 16),
                  const Expanded(child: _ListaHistorico()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCabecalho() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1D9E75),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Histórico',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _mesAno,
            style: const TextStyle(color: Color(0xFFC7F0DF), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.black54),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                '01/03/2026  →  30/03/2026',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartoesResumo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _CartaoResumo(label: 'Deslocamentos', valor: '${BancoMock.deslocamentos.length}')),
          const SizedBox(width: 12),
          Expanded(child: _CartaoResumo(label: 'Tempo total', valor: '22h')),
          const SizedBox(width: 12),
          Expanded(child: _CartaoResumo(label: 'Rota principal', valor: 'Casa → IFS')),
        ],
      ),
    );
  }
}

class _CartaoResumo extends StatelessWidget {
  final String label;
  final String valor;

  const _CartaoResumo({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text(valor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ListaHistorico extends StatelessWidget {
  const _ListaHistorico();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: BancoMock.deslocamentos.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _CartaoHistorico(entrada: BancoMock.deslocamentos[index]),
    );
  }
}

class _CartaoHistorico extends StatelessWidget {
  final Deslocamento entrada;

  const _CartaoHistorico({required this.entrada});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditarDeslocamentoScreen(entrada: entrada),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: BancoMock.rotaPorId(entrada.rotaId).cor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    BancoMock.rotaPorId(entrada.rotaId).nome,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entrada.data} · ${entrada.horarioSaida}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  if (entrada.observacao.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      entrada.observacao,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              BancoMock.duracaoDeslocamento(entrada),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: BancoMock.rotaPorId(entrada.rotaId).cor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
