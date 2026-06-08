import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/mock/banco_mock.dart';
import 'package:flutter/material.dart';
import '../../core/repositories/deslocamento_repositorio.dart';
import '../../core/repositories/rota_repositorio.dart';
import '../../core/widgets/barra_navegacao.dart';
import '../displacement/select_route_screen.dart';
import '../rotas/criar_rota_screen.dart';
import '../rotas/editar_rota_screen.dart';
import '../rotas/minhas_rotas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _assinaturaRotas = RotaRepositorio.buscarRotas(uid).listen(
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

  // ─── Helpers de data ──────────────────────────────────────────

  String get _saudacao {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Bom dia';
    if (hora < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  String get _dataHoje {
    final agora = DateTime.now();
    const meses = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
    ];
    const diasSemana = [
      'Domingo', 'Segunda-feira', 'Terça-feira', 'Quarta-feira',
      'Quinta-feira', 'Sexta-feira', 'Sábado',
    ];
    return '${diasSemana[agora.weekday % 7]}, ${agora.day} de ${meses[agora.month - 1]}';
  }

  // Formato dd/MM/yyyy — padrão usado para salvar deslocamentos no Firestore
  String get _dataHojeStr {
    final agora = DateTime.now();
    final dia = agora.day.toString().padLeft(2, '0');
    final mes = agora.month.toString().padLeft(2, '0');
    return '$dia/$mes/${agora.year}';
  }

  // ─── Computed a partir do Firestore ───────────────────────────

  bool get _ehNovoUsuario => _rotas.isEmpty && !_carregando;

  String get _tituloRotas => _totalDeslocamentosHoje > 0 ? 'Rotas recentes' : 'Suas rotas';

  int get _totalDeslocamentosHoje {
    final hoje = _dataHojeStr;
    return _deslocamentos.where((d) => d.data == hoje).length;
  }

  String get _tempoTotalHojeFormatado {
    final hoje = _dataHojeStr;
    final deHoje = _deslocamentos.where((d) => d.data == hoje).toList();
    if (deHoje.isEmpty) return '0 min';
    int totalMin = 0;
    for (final d in deHoje) {
      final partesSaida = d.horarioSaida.split(':');
      final partesChegada = d.horarioChegada.split(':');
      final saidaMin = int.parse(partesSaida[0]) * 60 + int.parse(partesSaida[1]);
      final chegadaMin = int.parse(partesChegada[0]) * 60 + int.parse(partesChegada[1]);
      final diferenca = chegadaMin - saidaMin;
      totalMin += diferenca < 0 ? diferenca + 24 * 60 : diferenca;
    }
    if (totalMin < 60) return '$totalMin min';
    final h = totalMin ~/ 60;
    final m = totalMin % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  int get _diaAtualIndex => (DateTime.now().weekday - 1) % 7;

  List<int> get _graficoSemana {
    final hoje = DateTime.now();
    final diaHoje = DateTime(hoje.year, hoje.month, hoje.day);
    final inicioSemana = diaHoje.subtract(Duration(days: diaHoje.weekday - 1));
    final contagem = List<int>.filled(7, 0);
    for (final d in _deslocamentos) {
      final partes = d.data.split('/');
      if (partes.length != 3) continue;
      final dia = int.tryParse(partes[0]);
      final mes = int.tryParse(partes[1]);
      final ano = int.tryParse(partes[2]);
      if (dia == null || mes == null || ano == null) continue;
      final dataDeslocamento = DateTime(ano, mes, dia);
      final diffDias = dataDeslocamento.difference(inicioSemana).inDays;
      if (diffDias < 0 || diffDias > 6) continue;
      contagem[diffDias]++;
    }
    return contagem;
  }

  String _ultimoUsoDaRota(int rotaId) {
    final lista = _deslocamentos.where((d) => d.rotaId == rotaId).toList();
    if (lista.isEmpty) return '—';
    return lista.last.data;
  }

  bool get _temHistorico => _deslocamentos.isNotEmpty;

  Rota get _rotaSugerida {
    if (_deslocamentos.isEmpty) return _rotas.first;
    final contagem = <int, int>{};
    for (final d in _deslocamentos) {
      contagem[d.rotaId] = (contagem[d.rotaId] ?? 0) + 1;
    }
    final idMaisUsado = contagem.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    try {
      return _rotas.firstWhere((r) => r.id == idMaisUsado);
    } catch (_) {
      return _rotas.first;
    }
  }

  String _saidaUsualDaRota(int rotaId) {
    final lista = _deslocamentos.where((d) => d.rotaId == rotaId).toList();
    if (lista.isEmpty) return '';
    int totalMin = 0;
    int count = 0;
    for (final d in lista) {
      try {
        final partes = d.horarioSaida.split(':');
        totalMin += int.parse(partes[0]) * 60 + int.parse(partes[1]);
        count++;
      } catch (_) {}
    }
    if (count == 0) return '';
    final mediaMin = totalMin ~/ count;
    final h = mediaMin ~/ 60;
    final m = mediaMin % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  // ─── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F3F2),
        bottomNavigationBar: BarraNavegacao(indiceSelecionado: 0),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1D9E75)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F2),
      bottomNavigationBar: const BarraNavegacao(indiceSelecionado: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCabecalho(),
            const SizedBox(height: 12),
            if (_ehNovoUsuario) ..._conteudoNovoUsuario(context),
            if (!_ehNovoUsuario && _temHistorico) ..._conteudoComSugestao(context),
            if (!_ehNovoUsuario && !_temHistorico) ..._conteudoNormal(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecalho() {
    if (_ehNovoUsuario) {
      return Container(
        width: double.infinity,
        color: const Color(0xFF1D9E75),
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá, bem-vindo!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'O MoveCity vai ajudar você a organizar\nseus deslocamentos diários.',
              style: TextStyle(fontSize: 13, color: Color(0xFFC7F0DF)),
            ),
            const SizedBox(height: 28),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(color: Color(0xFF0F614A), shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: const Color(0xFF1D9E75),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_saudacao, ${FirebaseAuth.instance.currentUser?.displayName ?? 'Usuário'}!',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            _dataHoje,
            style: const TextStyle(fontSize: 13, color: Color(0xFFC7F0DF)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCartaoEstatistica('Deslocamentos hoje', '$_totalDeslocamentosHoje'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildCartaoEstatistica('Tempo total hoje', _tempoTotalHojeFormatado),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartaoEstatistica(String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F614A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 10, color: Color(0xFFC7F0DF))),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  List<Widget> _conteudoNormal(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Iniciar deslocamento', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Toque para registrar sua saída', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectRouteScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D9E75),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Selecionar rota  →', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectRouteScreen()));
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: Color(0xFFE9F3DE), shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow, color: Color(0xFF1D9E75), size: 22),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      ..._buildSecaoRotas(context),
      const SizedBox(height: 20),
      ..._buildGrafico(),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _conteudoComSugestao(BuildContext context) {
    final rota = _rotaSugerida;
    final saidaUsual = _saidaUsualDaRota(rota.id);

    return [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F3DE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Sugestão para agora',
                      style: TextStyle(fontSize: 10, color: Color(0xFF3B6D11), fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(rota.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    '${rota.transporte} · ~${rota.tempoEstimadoMin} min${saidaUsual.isNotEmpty ? ' · Saída usual: $saidaUsual' : ''}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectRouteScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9E75),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text('Iniciar →', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      ..._buildSecaoRotas(context),
      const SizedBox(height: 20),
      ..._buildGrafico(),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _conteudoNovoUsuario(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Comece criando sua primeira rota', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Uma rota é um trajeto que você faz com frequência — por exemplo, casa até o trabalho.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CriarRotaScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9E75),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Criar minha primeira rota →', style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text('Já tem rotas? Importe do histórico', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _buildPassoOnboarding(1, 'Cadastre sua rota', temLinhaBaixo: true),
      _buildPassoOnboarding(2, 'Registre suas saídas', temLinhaBaixo: true),
      _buildPassoOnboarding(3, 'Acompanhe seu histórico', temLinhaBaixo: false),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _buildSecaoRotas(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_tituloRotas, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MinhasRotasScreen()));
              },
              child: const Text('Ver todas →', style: TextStyle(fontSize: 11, color: Color(0xFF1D9E75))),
            ),
          ],
        ),
      ),
      for (int i = 0; i < _rotas.length; i++) ...[
        if (i > 0) const SizedBox(height: 8),
        _buildCartaoRota(context, _rotas[i]),
      ],
    ];
  }

  Widget _buildCartaoRota(BuildContext context, Rota rota) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => EditarRotaScreen(rota: rota)));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(width: 14, height: 14, decoration: BoxDecoration(color: rota.cor, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rota.nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(_ultimoUsoDaRota(rota.id), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGrafico() {
    final alturas = _graficoSemana;
    if (alturas.isEmpty) return [];

    const dias = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
    final maximo = alturas.reduce((a, b) => a > b ? a : b);
    final semDados = alturas.every((v) => v == 0);

    return [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('Esta semana', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
      const SizedBox(height: 8),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < 7; i++)
                  _buildBarra(dias[i], alturas[i], maximo, i == _diaAtualIndex),
              ],
            ),
            if (semDados) ...[
              const SizedBox(height: 12),
              const Text('Nenhum deslocamento registrado ainda hoje.', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ],
        ),
      ),
    ];
  }

  Widget _buildBarra(String dia, int altura, int maximo, bool ehHoje) {
    final temDado = altura > 0;
    final alturaPixels = maximo > 0 ? (altura / maximo) * 44.0 : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: temDado ? alturaPixels : 4,
          decoration: BoxDecoration(
            color: temDado ? const Color(0xFF1D9E75) : const Color(0xFFDFDEDC),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(dia, style: TextStyle(fontSize: 10, color: (temDado || ehHoje) ? Colors.black87 : Colors.grey)),
        if (ehHoje)
          Container(
            width: 20,
            height: 2,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(color: const Color(0xFF1D9E75), borderRadius: BorderRadius.circular(1)),
          )
        else
          const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildPassoOnboarding(int numero, String descricao, {required bool temLinhaBaixo}) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: const Color(0xFFE9F3DE), borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: Text('$numero', style: const TextStyle(fontSize: 13, color: Color(0xFF1D9E75), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Text(descricao, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        if (temLinhaBaixo)
          Container(
            margin: const EdgeInsets.only(left: 44),
            width: 2,
            height: 8,
            color: const Color(0xFF1D9E75),
          ),
      ],
    );
  }
}
