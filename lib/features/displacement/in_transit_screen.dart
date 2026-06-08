import 'package:flutter/material.dart';
import '../../app_routes.dart';
import '../../core/mock/banco_mock.dart';
import '../../core/repositories/deslocamento_repositorio.dart';

class InTransitScreen extends StatelessWidget {
  final Rota rota;
  final Deslocamento deslocamento;

  const InTransitScreen({
    super.key,
    required this.rota,
    required this.deslocamento,
  });

  static const Color _fundoMapa = Color(0xFFE3E8E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundoMapa,
      body: Stack(
        children: [
          const Positioned.fill(child: _MapaMockado()),
          Positioned(
            top: MediaQuery.of(context).padding.top + 22,
            left: 16,
            child: _BotaoVoltar(onTap: () => Navigator.maybePop(context)),
          ),
          const Positioned(top: 150, right: 18, child: _BotaoLocalizacao()),
          Positioned.fill(child: _TrajetoMockado(destino: rota.destino)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _ResumoViagem(rota: rota, deslocamento: deslocamento),
          ),
        ],
      ),
    );
  }
}

class _MapaMockado extends StatelessWidget {
  const _MapaMockado();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MapaPainter());
  }
}

class _MapaPainter extends CustomPainter {
  static const Color _quadra = Color(0xFFE3E8E0);
  static const Color _rua = Colors.white;
  static const Color _sombra = Color(0xFFE8ECE5);

  @override
  void paint(Canvas canvas, Size size) {
    final fundo = Paint()..color = _quadra;
    canvas.drawRect(Offset.zero & size, fundo);

    final rua = Paint()
      ..color = _rua
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 8;

    final ruasVerticais = <double>[
      size.width * 0.16,
      size.width * 0.36,
      size.width * 0.58,
      size.width * 0.82,
    ];
    final ruasHorizontais = <double>[
      size.height * 0.12,
      size.height * 0.20,
      size.height * 0.30,
      size.height * 0.43,
      size.height * 0.56,
      size.height * 0.68,
    ];

    for (final x in ruasVerticais) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), rua);
    }

    for (final y in ruasHorizontais) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), rua);
    }

    final sombra = Paint()
      ..color = _sombra
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final x in ruasVerticais) {
      canvas.drawLine(Offset(x + 5, 0), Offset(x + 5, size.height), sombra);
    }

    for (final y in ruasHorizontais) {
      canvas.drawLine(Offset(0, y + 5), Offset(size.width, y + 5), sombra);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrajetoMockado extends StatelessWidget {
  final String destino;

  const _TrajetoMockado({required this.destino});

  static const Color _verde = Color(0xFF1D9E75);
  static const Color _vermelhoDestino = Color(0xFFD62F2F);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;
        final altura = constraints.maxHeight;
        final yLinha = altura * 0.31;
        final pontoAtual = Offset(largura * 0.37, yLinha);
        final pontoDestino = Offset(largura * 0.78, yLinha);

        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: yLinha - 5,
              child: Container(height: 10, color: _verde),
            ),
            Positioned(
              left: pontoAtual.dx - 10,
              top: pontoAtual.dy - 10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _verde,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 2.5,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: pontoDestino.dx - 34,
              top: pontoDestino.dy - 22,
              width: 68,
              child: Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _vermelhoDestino,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.20),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 3, height: 16, color: _vermelhoDestino),
                  const SizedBox(height: 2),
                  Text(
                    destino.isEmpty ? 'Destino' : destino,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF3A3A3A),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BotaoVoltar extends StatelessWidget {
  const _BotaoVoltar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chevron_left, size: 18, color: Color(0xFF303030)),
              SizedBox(width: 2),
              Text(
                'Voltar',
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotaoLocalizacao extends StatelessWidget {
  const _BotaoLocalizacao();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.my_location, color: Color(0xFF777777), size: 18),
    );
  }
}

class _ResumoViagem extends StatefulWidget {
  final Rota rota;
  final Deslocamento deslocamento;

  const _ResumoViagem({required this.rota, required this.deslocamento});

  @override
  State<_ResumoViagem> createState() => _ResumoViagemState();
}

class _ResumoViagemState extends State<_ResumoViagem> {
  static const Color _verde = Color(0xFF1D9E75);

  bool _salvandoChegada = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        18,
        10,
        18,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFD7D7D7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.rota.nome,
            style: const TextStyle(
              color: Color(0xFF202221),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Em andamento',
              style: TextStyle(
                color: Color(0xFF3D785F),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetricaViagem(
                  rotulo: 'Transporte',
                  valor: widget.deslocamento.transporte,
                ),
              ),
              const _DivisorMetrica(),
              Expanded(
                child: _MetricaViagem(
                  rotulo: 'Saída',
                  valor: widget.deslocamento.horarioSaida,
                ),
              ),
              const _DivisorMetrica(),
              Expanded(
                child: _MetricaViagem(
                  rotulo: 'Estimativa',
                  valor: '~${widget.rota.tempoEstimadoMin} min',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_forward, color: _verde, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rota.destino.isEmpty
                            ? 'Siga até o destino'
                            : widget.rota.destino,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF202221),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'rota em andamento',
                        style: TextStyle(
                          color: Color(0xFF8C8C8C),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _salvandoChegada ? null : _confirmarChegada,
              style: ElevatedButton.styleFrom(
                backgroundColor: _verde,
                foregroundColor: Colors.white,
                elevation: 7,
                shadowColor: _verde.withValues(alpha: 0.28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _salvandoChegada
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Text(
                      'Cheguei ao destino',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarChegada() async {
    final agora = TimeOfDay.now();
    final horarioChegada =
        '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}';

    final deslocamentoFinalizado = Deslocamento(
      id: widget.deslocamento.id,
      rotaId: widget.deslocamento.rotaId,
      data: widget.deslocamento.data,
      horarioSaida: widget.deslocamento.horarioSaida,
      horarioChegada: horarioChegada,
      transporte: widget.deslocamento.transporte,
      observacao: widget.deslocamento.observacao,
    );

    setState(() => _salvandoChegada = true);

    try {
      await DeslocamentoRepositorio.salvar(deslocamentoFinalizado);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao registrar chegada. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _salvandoChegada = false);
    }
  }
}

class _MetricaViagem extends StatelessWidget {
  const _MetricaViagem({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFF8B8B8B), fontSize: 9),
        ),
        const SizedBox(height: 3),
        Text(
          valor,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF202221),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _DivisorMetrica extends StatelessWidget {
  const _DivisorMetrica();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFFE0E0E0),
    );
  }
}
