import 'package:flutter/material.dart';
import '../../core/mock/banco_mock.dart';
import '../../core/services/deslocamento_service.dart';
import '../../core/widgets/barra_navegacao.dart';

class EditarDeslocamentoScreen extends StatefulWidget {
  final Deslocamento entrada;
  final String nomeRota;

  const EditarDeslocamentoScreen({
    super.key,
    required this.entrada,
    required this.nomeRota,
  });

  @override
  State<EditarDeslocamentoScreen> createState() => _EditarDeslocamentoScreenState();
}

class _EditarDeslocamentoScreenState extends State<EditarDeslocamentoScreen> {
  final _observacaoController = TextEditingController();

  final List<String> _opcoesTransporte = ['Ônibus', 'Carro', 'A pé', 'Moto'];

  late String _transporteSelecionado;
  late TimeOfDay _horarioSaida;
  late TimeOfDay _horarioChegada;
  bool _salvando = false;
  bool _excluindo = false;

  @override
  void initState() {
    super.initState();
    _observacaoController.text = widget.entrada.observacao;
    _transporteSelecionado = widget.entrada.transporte;
    _horarioSaida = _parsarHorario(widget.entrada.horarioSaida);
    _horarioChegada = _parsarHorario(widget.entrada.horarioChegada);
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  TimeOfDay _parsarHorario(String horario) {
    final partes = horario.split(':');
    return TimeOfDay(hour: int.parse(partes[0]), minute: int.parse(partes[1]));
  }

  String _formatarHorario(TimeOfDay horario) {
    return '${horario.hour.toString().padLeft(2, '0')}:${horario.minute.toString().padLeft(2, '0')}';
  }

  int get _duracaoMin {
    final saidaMin = _horarioSaida.hour * 60 + _horarioSaida.minute;
    final chegadaMin = _horarioChegada.hour * 60 + _horarioChegada.minute;
    final diferenca = chegadaMin - saidaMin;
    return diferenca < 0 ? diferenca + 24 * 60 : diferenca;
  }

  String get _duracaoFormatada {
    final min = _duracaoMin;
    if (min < 60) return '$min min';
    final horas = min ~/ 60;
    final minutos = min % 60;
    return minutos == 0 ? '${horas}h' : '${horas}h ${minutos}min';
  }

  Future<void> _salvarAlteracoes() async {
    setState(() => _salvando = true);

    final deslocamentoAtualizado = Deslocamento(
      id: widget.entrada.id,
      rotaId: widget.entrada.rotaId,
      data: widget.entrada.data,
      horarioSaida: _formatarHorario(_horarioSaida),
      horarioChegada: _formatarHorario(_horarioChegada),
      transporte: _transporteSelecionado,
      observacao: _observacaoController.text.trim(),
    );

    try {
      await DeslocamentoService().atualizarDeslocamento(deslocamentoAtualizado);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar alterações. Tente novamente.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  Future<void> _excluirDeslocamento() async {
    setState(() => _excluindo = true);
    try {
      await DeslocamentoService().excluirDeslocamento(widget.entrada.id.toString());
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao excluir deslocamento. Tente novamente.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _excluindo = false);
      }
    }
  }

  Future<void> _selecionarHorario(BuildContext context, {required bool ehSaida}) async {
    final inicial = ehSaida ? _horarioSaida : _horarioChegada;
    final escolhido = await showTimePicker(
      context: context,
      initialTime: inicial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF1D9E75),
                onPrimary: Colors.white,
                onSurface: Color(0xFF202221),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (escolhido == null) return;
    setState(() {
      if (ehSaida) {
        _horarioSaida = escolhido;
      } else {
        _horarioChegada = escolhido;
      }
    });
  }

  void _mostrarConfirmacaoExclusao() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.priority_high, color: Colors.red, size: 28),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Excluir deslocamento?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'O registro de ${widget.entrada.data} às ${widget.entrada.horarioSaida} será excluído permanentemente.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _excluindo ? null : _excluirDeslocamento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _excluindo
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2.2,
                            ),
                          )
                        : const Text(
                            'Sim, excluir',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F2),
      bottomNavigationBar: const BarraNavegacao(indiceSelecionado: 3),
      body: Column(
        children: [
          _buildCabecalho(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Rota'),
                  const SizedBox(height: 6),
                  _buildCampoRotaReadOnly(),
                  const SizedBox(height: 16),
                  _buildLabel('Meio de transporte'),
                  const SizedBox(height: 8),
                  _buildSeletorTransporte(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Horário de saída'),
                            const SizedBox(height: 6),
                            _buildCampoHorario(context, ehSaida: true),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Horário de chegada'),
                            const SizedBox(height: 6),
                            _buildCampoHorario(context, ehSaida: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCardDuracao(),
                  const SizedBox(height: 16),
                  _buildLabel('Observação'),
                  const SizedBox(height: 6),
                  _buildCampoObservacao(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _salvando ? null : _salvarAlteracoes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9E75),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _salvando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.2,
                              ),
                            )
                          : const Text(
                              'Salvar alterações',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _mostrarConfirmacaoExclusao,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Excluir este deslocamento',
                        style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Esta ação não pode ser desfeita.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCabecalho(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1D9E75),
      padding: EdgeInsets.fromLTRB(4, MediaQuery.of(context).padding.top + 8, 20, 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Editar deslocamento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '${widget.entrada.data} · ${widget.entrada.horarioSaida}',
                style: const TextStyle(fontSize: 13, color: Color(0xFFC7F0DF)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String texto) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildCampoRotaReadOnly() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDCDCDC)),
      ),
      child: Text(
        widget.nomeRota,
        style: const TextStyle(fontSize: 15, color: Color(0xFF808080)),
      ),
    );
  }

  Widget _buildSeletorTransporte() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final opcao in _opcoesTransporte)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _transporteSelecionado = opcao),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _transporteSelecionado == opcao
                        ? const Color(0xFF1D9E75)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _transporteSelecionado == opcao
                          ? const Color(0xFF1D9E75)
                          : const Color(0xFFDCDCDC),
                    ),
                  ),
                  child: Text(
                    opcao,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _transporteSelecionado == opcao ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCampoHorario(BuildContext context, {required bool ehSaida}) {
    final horario = ehSaida ? _horarioSaida : _horarioChegada;

    return GestureDetector(
      onTap: () => _selecionarHorario(context, ehSaida: ehSaida),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ehSaida ? const Color(0xFF1D9E75) : const Color(0xFFDCDCDC),
            width: ehSaida ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          _formatarHorario(horario),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: ehSaida ? const Color(0xFF1D9E75) : const Color(0xFF202221),
          ),
        ),
      ),
    );
  }

  Widget _buildCardDuracao() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F3DE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA3CC59), width: 0.75),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Duração calculada',
            style: TextStyle(fontSize: 13, color: Color(0xFF3B6D11)),
          ),
          Text(
            _duracaoFormatada,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B6D11),
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
        hintText: 'Ex: Ônibus atrasado ~5 min na parada',
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 1.5),
        ),
      ),
    );
  }
}
