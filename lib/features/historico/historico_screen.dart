import 'package:flutter/material.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1D9E75),
        unselectedItemColor: Colors.black54,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Registrar'),
          BottomNavigationBarItem(icon: Icon(Icons.list_outlined), label: 'Rotas'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: 'Histórico'),
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
          Expanded(child: _CartaoResumo(label: 'Deslocamentos', valor: '31')),
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
    const entradas = [
      _EntradaHistorico(
        titulo: 'Casa → IFS',
        subtitulo: 'Hoje, 07:42',
        duracao: '37 min',
        cor: Color(0xFF1D9E75),
        observacao: '',
      ),
      _EntradaHistorico(
        titulo: 'IFS → Trabalho',
        subtitulo: 'Hoje, 13:10',
        duracao: '14 min',
        cor: Color(0xFF1D9E75),
        observacao: '',
      ),
      _EntradaHistorico(
        titulo: 'Casa → IFS',
        subtitulo: 'Ontem, 07:55',
        duracao: '48 min',
        cor: Color(0xFFF57C00),
        observacao: 'acima do normal',
      ),
      _EntradaHistorico(
        titulo: 'IFS → Trabalho',
        subtitulo: 'Ontem, 13:20',
        duracao: '12 min',
        cor: Color(0xFF1D9E75),
        observacao: '',
      ),
      _EntradaHistorico(
        titulo: 'Casa → Shopping Jardins',
        subtitulo: '27/03, 18:00',
        duracao: '22 min',
        cor: Color(0xFF1D9E75),
        observacao: '',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: entradas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _CartaoHistorico(entrada: entradas[index]),
    );
  }
}

class _EntradaHistorico {
  final String titulo;
  final String subtitulo;
  final String duracao;
  final Color cor;
  final String observacao;

  const _EntradaHistorico({
    required this.titulo,
    required this.subtitulo,
    required this.duracao,
    required this.cor,
    required this.observacao,
  });
}

class _CartaoHistorico extends StatelessWidget {
  final _EntradaHistorico entrada;

  const _CartaoHistorico({required this.entrada});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            decoration: BoxDecoration(color: entrada.cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entrada.titulo,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  entrada.subtitulo,
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
            entrada.duracao,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: entrada.cor),
          ),
        ],
      ),
    );
  }
}
