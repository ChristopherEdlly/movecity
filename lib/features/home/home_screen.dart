import 'package:flutter/material.dart';
import '../../core/mock/banco_mock.dart';
import '../../core/widgets/barra_navegacao.dart';
import '../displacement/select_route_screen.dart';
import '../rotas/criar_rota_screen.dart';
import '../rotas/editar_rota_screen.dart';
import '../rotas/minhas_rotas_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  bool get _ehNovoUsuario => BancoMock.rotas.isEmpty;
  String get _tituloRotas =>
      BancoMock.totalDeslocamentosHoje > 0 ? 'Rotas recentes' : 'Suas rotas';

  @override
  Widget build(BuildContext context) {
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
            if (!_ehNovoUsuario && BancoMock.sugestaoAtual != null) ..._conteudoComSugestao(context),
            if (!_ehNovoUsuario && BancoMock.sugestaoAtual == null) ..._conteudoNormal(context),
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
            '$_saudacao, ${BancoMock.usuarioLogado.nome}!',
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
                child: _buildCartaoEstatistica('Deslocamentos hoje', '${BancoMock.totalDeslocamentosHoje}'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildCartaoEstatistica('Tempo total hoje', BancoMock.tempoTotalHojeFormatado),
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
      if (BancoMock.dicaAtual != null) ...[
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE9F3DE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA3CC59), width: 0.75),
          ),
          child: Text(BancoMock.dicaAtual!, style: const TextStyle(fontSize: 12, color: Color(0xFF3B6D11))),
        ),
      ] else
        const SizedBox(height: 24),
    ];
  }

  List<Widget> _conteudoComSugestao(BuildContext context) {
    final sugestao = BancoMock.sugestaoAtual!;
    final alerta = BancoMock.alertaAtual;

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
                  Text(sugestao.rota, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    '${sugestao.transporte} · ${sugestao.tempoEstimado} · Saída ideal: ${sugestao.saidaIdeal}',
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
      if (alerta != null) ...[
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFB74D), width: 0.75),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('!  ', style: TextStyle(color: Color(0xFFCC6600), fontWeight: FontWeight.bold, fontSize: 13)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alerta.titulo, style: const TextStyle(color: Color(0xFFCC6600), fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(alerta.mensagem, style: const TextStyle(color: Color(0xFFCC6600), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
    final rotas = BancoMock.rotas;
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
      for (int i = 0; i < rotas.length; i++) ...[
        if (i > 0) const SizedBox(height: 8),
        _buildCartaoRota(context, rotas[i]),
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
                  Text(BancoMock.ultimoUsoDaRota(rota.id), style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
    final alturas = BancoMock.graficoSemana;
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
                  _buildBarra(dias[i], alturas[i], maximo, i == BancoMock.diaAtualIndex),
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
