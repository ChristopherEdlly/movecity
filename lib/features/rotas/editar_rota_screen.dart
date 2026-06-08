import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/mock/banco_mock.dart';
import '../../core/repositories/deslocamento_repositorio.dart';
import '../../core/repositories/rota_repositorio.dart';
import '../../core/widgets/barra_navegacao.dart';

class EditarRotaScreen extends StatefulWidget {
  final Rota rota;

  const EditarRotaScreen({super.key, required this.rota});

  @override
  State<EditarRotaScreen> createState() => _EditarRotaScreenState();
}

class _EditarRotaScreenState extends State<EditarRotaScreen> {
  final _nomeController = TextEditingController();
  final _origemController = TextEditingController();
  final _destinoController = TextEditingController();
  final _tempoController = TextEditingController();
  final _observacoesController = TextEditingController();

  String _transporteSelecionado = 'Ônibus';
  bool _salvando = false;
  bool _excluindo = false;
  int _quantidadeUsos = 0;

  StreamSubscription<List<Deslocamento>>? _assinaturaDeslocamentos;

  final List<String> _opcoesTransporte = [
    'Ônibus', 'Carro', 'A pé', 'Moto', 'Bicicleta',
  ];

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.rota.nome;
    _origemController.text = widget.rota.origem;
    _destinoController.text = widget.rota.destino;
    _tempoController.text = '${widget.rota.tempoEstimadoMin}';
    _observacoesController.text = widget.rota.observacoes ?? '';
    _transporteSelecionado = widget.rota.transporte;

    _assinaturaDeslocamentos = DeslocamentoRepositorio.buscarDeslocamentos(widget.rota.id).listen(
      (lista) {
        if (!mounted) return;
        setState(() => _quantidadeUsos = lista.length);
      },
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _origemController.dispose();
    _destinoController.dispose();
    _tempoController.dispose();
    _observacoesController.dispose();
    _assinaturaDeslocamentos?.cancel();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    final nome = _nomeController.text.trim();
    final origem = _origemController.text.trim();
    final destino = _destinoController.text.trim();
    final tempoTexto = _tempoController.text.trim();

    if (nome.isEmpty || origem.isEmpty || destino.isEmpty || tempoTexto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    setState(() => _salvando = true);

    final rotaAtualizada = Rota(
      id: widget.rota.id,
      usuarioId: widget.rota.usuarioId,
      nome: nome,
      origem: origem,
      destino: destino,
      tempoEstimadoMin: int.tryParse(tempoTexto) ?? widget.rota.tempoEstimadoMin,
      transporte: _transporteSelecionado,
      cor: widget.rota.cor,
      observacoes: _observacoesController.text.trim().isEmpty
          ? null
          : _observacoesController.text.trim(),
    );

    try {
      await RotaRepositorio.salvar(rotaAtualizada);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar alterações. Tente novamente.')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _excluirRota() async {
    Navigator.pop(context); // fecha o dialog
    setState(() => _excluindo = true);
    try {
      await RotaRepositorio.excluir(widget.rota.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _excluindo = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao excluir rota. Tente novamente.')),
        );
      }
    }
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
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.priority_high, color: Colors.red, size: 32),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Excluir rota?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.rota.nome} · $_quantidadeUsos deslocamentos',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Todo o histórico vinculado a esta rota\ntambém será excluído. Essa ação é permanente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _excluirRota,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Sim, excluir rota e histórico',
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
      bottomNavigationBar: const BarraNavegacao(indiceSelecionado: 2),
      body: Column(
        children: [
          _buildCabecalho(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F3DE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_quantidadeUsos usos registrados',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3B6D11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Nome da rota'),
                  const SizedBox(height: 6),
                  _buildCampoTexto(_nomeController, 'Casa → IFS'),
                  const SizedBox(height: 16),
                  _buildLabel('Origem'),
                  const SizedBox(height: 6),
                  _buildCampoTexto(_origemController, 'Ex: Rua das Flores, 10'),
                  const SizedBox(height: 16),
                  _buildLabel('Destino'),
                  const SizedBox(height: 6),
                  _buildCampoTexto(_destinoController, 'Ex: IFS Aracaju'),
                  const SizedBox(height: 16),
                  _buildLabel('Tempo estimado (min)'),
                  const SizedBox(height: 6),
                  _buildCampoTexto(
                    _tempoController,
                    '35',
                    teclado: TextInputType.number,
                    formatador: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Meio de transporte'),
                  const SizedBox(height: 8),
                  _buildSeletorTransporte(),
                  const SizedBox(height: 16),
                  _buildLabel('Observações (opcional)'),
                  const SizedBox(height: 6),
                  _buildCampoTexto(
                    _observacoesController,
                    'Ex: Ponto de ônibus na esquina',
                    linhas: 2,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_salvando || _excluindo) ? null : _salvarAlteracoes,
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
                      onPressed: (_salvando || _excluindo) ? null : _mostrarConfirmacaoExclusao,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _excluindo ? Colors.red.shade100 : Colors.red.shade50,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _excluindo
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                strokeWidth: 2.2,
                              ),
                            )
                          : const Text(
                              'Excluir rota',
                              style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Excluir a rota também remove todo o histórico\nde deslocamentos vinculado a ela.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey),
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
          const Text(
            'Editar rota',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildCampoTexto(
    TextEditingController controller,
    String placeholder, {
    TextInputType teclado = TextInputType.text,
    List<TextInputFormatter>? formatador,
    int linhas = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: teclado,
      inputFormatters: formatador,
      minLines: linhas,
      maxLines: linhas,
      decoration: InputDecoration(
        hintText: placeholder,
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
                    color: _transporteSelecionado == opcao ? const Color(0xFF1D9E75) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _transporteSelecionado == opcao ? const Color(0xFF1D9E75) : const Color(0xFFDCDCDC),
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
}
