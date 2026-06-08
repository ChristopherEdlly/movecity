import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/mock/banco_mock.dart';
import 'package:flutter/material.dart';
import '../../core/repositories/deslocamento_repositorio.dart';
import '../../core/repositories/rota_repositorio.dart';
import '../../core/widgets/barra_navegacao.dart';
import 'editar_deslocamento_screen.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<Rota> _rotas = [];
  List<Deslocamento> _deslocamentos = [];
  bool _carregando = true;

  DateTime? _dataInicio;
  DateTime? _dataFim;

  StreamSubscription<List<Rota>>? _assinaturaRotas;
  StreamSubscription<List<Deslocamento>>? _assinaturaDeslocamentos;

  @override
  void initState() {
    super.initState();
    _ouvirRotas();
  }

  void _ouvirRotas() {
    _assinaturaRotas = RotaRepositorio.buscarRotas(FirebaseAuth.instance.currentUser!.uid).listen(
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
    _assinaturaRotas?.cancel();
    _assinaturaDeslocamentos?.cancel();
    super.dispose();
  }

  // ─── Filtro de data ───────────────────────────────────────────

  List<Deslocamento> get _deslocamentosFiltrados {
    if (_dataInicio == null || _dataFim == null) return _deslocamentos;
    return _deslocamentos.where((d) {
      try {
        final partes = d.data.split('/');
        final data = DateTime(
          int.parse(partes[2]),
          int.parse(partes[1]),
          int.parse(partes[0]),
        );
        return !data.isBefore(_dataInicio!) && !data.isAfter(_dataFim!);
      } catch (_) {
        return true;
      }
    }).toList();
  }

  String get _textoFiltroData {
    if (_dataInicio == null || _dataFim == null) return 'Filtrar por data';
    String f(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return '${f(_dataInicio!)}  →  ${f(_dataFim!)}';
  }

  Future<void> _abrirFiltroData() async {
    final resultado = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dataInicio != null && _dataFim != null
          ? DateTimeRange(start: _dataInicio!, end: _dataFim!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1D9E75),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (resultado != null && mounted) {
      setState(() {
        _dataInicio = resultado.start;
        _dataFim = resultado.end;
      });
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────

  String get _mesAno {
    final agora = DateTime.now();
    const meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    return '${meses[agora.month - 1]} de ${agora.year}';
  }

  String _calcularDuracao(Deslocamento d) {
    try {
      final partesSaida = d.horarioSaida.split(':');
      final partesChegada = d.horarioChegada.split(':');
      final saidaMin = int.parse(partesSaida[0]) * 60 + int.parse(partesSaida[1]);
      final chegadaMin = int.parse(partesChegada[0]) * 60 + int.parse(partesChegada[1]);
      var diff = chegadaMin - saidaMin;
      if (diff < 0) diff += 24 * 60;
      if (diff < 60) return '${diff}min';
      final h = diff ~/ 60;
      final m = diff % 60;
      return m == 0 ? '${h}h' : '${h}h${m}min';
    } catch (_) {
      return '—';
    }
  }

  String get _tempoTotalFormatado {
    int totalMin = 0;
    for (final d in _deslocamentosFiltrados) {
      try {
        final partesSaida = d.horarioSaida.split(':');
        final partesChegada = d.horarioChegada.split(':');
        final saidaMin = int.parse(partesSaida[0]) * 60 + int.parse(partesSaida[1]);
        final chegadaMin = int.parse(partesChegada[0]) * 60 + int.parse(partesChegada[1]);
        var diff = chegadaMin - saidaMin;
        if (diff < 0) diff += 24 * 60;
        totalMin += diff;
      } catch (_) {}
    }
    if (totalMin == 0) return '0 min';
    if (totalMin < 60) return '$totalMin min';
    final h = totalMin ~/ 60;
    final m = totalMin % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  String get _rotaPrincipal {
    if (_deslocamentosFiltrados.isEmpty || _rotas.isEmpty) return '—';
    final contagem = <int, int>{};
    for (final d in _deslocamentosFiltrados) {
      contagem[d.rotaId] = (contagem[d.rotaId] ?? 0) + 1;
    }
    final idMaisUsado = contagem.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    try {
      return _rotas.firstWhere((r) => r.id == idMaisUsado).nome;
    } catch (_) {
      return '—';
    }
  }

  // ─── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BarraNavegacao(indiceSelecionado: 3),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF1D9E75))),
      );
    }

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
                  Expanded(
                    child: _deslocamentosFiltrados.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum deslocamento encontrado.',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          )
                        : _ListaHistorico(
                            deslocamentos: _deslocamentosFiltrados,
                            rotas: _rotas,
                            calcularDuracao: _calcularDuracao,
                          ),
                  ),
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
    final temFiltro = _dataInicio != null && _dataFim != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: _abrirFiltroData,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: temFiltro ? const Color(0xFF1D9E75) : Colors.black54,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _textoFiltroData,
                  style: TextStyle(
                    fontSize: 14,
                    color: temFiltro ? Colors.black87 : Colors.black45,
                  ),
                ),
              ),
              GestureDetector(
                onTap: temFiltro
                    ? () => setState(() {
                          _dataInicio = null;
                          _dataFim = null;
                        })
                    : _abrirFiltroData,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Icon(
                    temFiltro ? Icons.close : Icons.tune,
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartoesResumo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _CartaoResumo(label: 'Deslocamentos', valor: '${_deslocamentosFiltrados.length}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _CartaoResumo(label: 'Tempo total', valor: _tempoTotalFormatado),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _CartaoResumo(label: 'Rota principal', valor: _rotaPrincipal),
          ),
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
  final List<Deslocamento> deslocamentos;
  final List<Rota> rotas;
  final String Function(Deslocamento) calcularDuracao;

  const _ListaHistorico({
    required this.deslocamentos,
    required this.rotas,
    required this.calcularDuracao,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: deslocamentos.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final d = deslocamentos[index];
        Rota? rota;
        try {
          rota = rotas.firstWhere((r) => r.id == d.rotaId);
        } catch (_) {
          rota = null;
        }
        return _CartaoHistorico(
          entrada: d,
          rota: rota,
          duracao: calcularDuracao(d),
        );
      },
    );
  }
}

class _CartaoHistorico extends StatelessWidget {
  final Deslocamento entrada;
  final Rota? rota;
  final String duracao;

  const _CartaoHistorico({
    required this.entrada,
    required this.rota,
    required this.duracao,
  });

  @override
  Widget build(BuildContext context) {
    final Color cor = rota?.cor ?? Colors.grey;
    final String nomeRota = rota?.nome ?? '—';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditarDeslocamentoScreen(entrada: entrada, nomeRota: nomeRota),
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
                color: cor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomeRota,
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
              duracao,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
