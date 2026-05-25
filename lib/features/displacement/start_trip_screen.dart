import 'package:flutter/material.dart';
import '../../core/widgets/barra_navegacao.dart';

class StartTripScreen extends StatefulWidget {
  const StartTripScreen({super.key});

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  static const Color _verde = Color(0xFF1D9E75);
  static const Color _fundo = Color(0xFFF3F3F2);
  static const Color _fundoCartaoRota = Color(0xFFEAF5E2);

  final TextEditingController _observacaoController = TextEditingController();
  final List<String> _opcoesTransporte = const [
    'Ônibus', 'Carro', 'A pé', 'Moto', 'Bicicleta',
  ];

  TimeOfDay _horarioSaida = TimeOfDay.now();
  String _transporteSelecionado = 'Ônibus';

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
                children: [
                  _buildIndicadorPassos(),
                  const SizedBox(height: 14),
                  _buildCartaoRotaSelecionada(),
                  const SizedBox(height: 18),
                  _buildLabel('Horário de saída'),
                  const SizedBox(height: 6),
                  _buildCampoHorario(context),
                  const SizedBox(height: 18),
                  _buildLabel('Meio de transporte'),
                  const SizedBox(height: 8),
                  _buildSeletorTransporte(),
                  const SizedBox(height: 16),
                  _buildLabel('Observação (opcional)'),
                  const SizedBox(height: 7),
                  _buildCampoObservacao(),
                  const SizedBox(height: 20),
                  _buildBotaoConfirmar(),
                  const SizedBox(height: 12),
                  const Text(
                    'Você registrará a chegada quando chegar ao destino.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF858585)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecalho(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _verde,
      padding: EdgeInsets.fromLTRB(4, MediaQuery.of(context).padding.top + 8, 20, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
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
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Selecione a rota e confirme a saída',
                    style: TextStyle(fontSize: 13, color: Color(0xFFC7F0DF)),
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          _IndicadorPasso(numero: '✓', label: 'Rota', estado: _EstadoPasso.concluido),
          Expanded(child: _DivisorPasso(ativo: true)),
          _IndicadorPasso(numero: '2', label: 'Saída', estado: _EstadoPasso.ativo),
          Expanded(child: _DivisorPasso()),
          _IndicadorPasso(numero: '3', label: 'Chegada'),
        ],
      ),
    );
  }

  Widget _buildCartaoRotaSelecionada() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _fundoCartaoRota,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFA3CC59), width: 1.2),
      ),
      child: const Row(
        children: [
          CircleAvatar(radius: 7, backgroundColor: _verde),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Casa → IFS',
                  style: TextStyle(color: Color(0xFF13694F), fontSize: 16, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  'Ônibus · ~35 min estimados',
                  style: TextStyle(color: Color(0xFF3D785F), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoHorario(BuildContext context) {
    final horarioFormatado =
        '${_horarioSaida.hour.toString().padLeft(2, '0')}:${_horarioSaida.minute.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selecionarHorario(context),
        borderRadius: BorderRadius.circular(11),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: _verde, width: 1.7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                horarioFormatado,
                style: const TextStyle(
                  color: _verde,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'toque para editar',
                style: TextStyle(color: Color(0xFF858585), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selecionarHorario(BuildContext context) async {
    final horarioEscolhido = await showTimePicker(
      context: context,
      initialTime: _horarioSaida,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: _verde,
                onPrimary: Colors.white,
                onSurface: Color(0xFF202221),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (horarioEscolhido == null) return;
    setState(() => _horarioSaida = horarioEscolhido);
  }

  Widget _buildSeletorTransporte() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final transporte in _opcoesTransporte)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _transporteSelecionado = transporte),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _transporteSelecionado == transporte ? _verde : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _transporteSelecionado == transporte ? _verde : const Color(0xFFE0E0DD),
                    ),
                  ),
                  child: Text(
                    transporte,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _transporteSelecionado == transporte ? Colors.white : const Color(0xFF777777),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCampoObservacao() {
    return TextField(
      controller: _observacaoController,
      minLines: 1,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Observação (opcional)',
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _verde, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildBotaoConfirmar() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _verde,
          foregroundColor: Colors.white,
          elevation: 7,
          shadowColor: _verde.withValues(alpha: 0.28),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          'Confirmar saída',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildLabel(String texto) {
    return Text(
      texto,
      style: const TextStyle(color: Color(0xFF777777), fontSize: 13, fontWeight: FontWeight.w600),
    );
  }
}

enum _EstadoPasso { inativo, ativo, concluido }

class _IndicadorPasso extends StatelessWidget {
  final String numero;
  final String label;
  final _EstadoPasso estado;

  const _IndicadorPasso({
    required this.numero,
    required this.label,
    this.estado = _EstadoPasso.inativo,
  });

  static const Color _verde = Color(0xFF1D9E75);

  @override
  Widget build(BuildContext context) {
    final ativo = estado == _EstadoPasso.ativo || estado == _EstadoPasso.concluido;
    final cor = ativo ? _verde : const Color(0xFFCFCFCF);

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          child: Text(
            numero,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          label,
          style: TextStyle(
            color: ativo ? _verde : const Color(0xFF909090),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DivisorPasso extends StatelessWidget {
  final bool ativo;

  const _DivisorPasso({this.ativo = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 24),
      color: ativo ? const Color(0xFF1D9E75) : const Color(0xFFDCDCDC),
    );
  }
}
