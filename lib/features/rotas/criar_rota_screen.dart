import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/widgets/barra_navegacao.dart';

class CriarRotaScreen extends StatefulWidget {
  const CriarRotaScreen({super.key});

  @override
  State<CriarRotaScreen> createState() => _CriarRotaScreenState();
}

class _CriarRotaScreenState extends State<CriarRotaScreen> {
  final _nomeController = TextEditingController();
  final _origemController = TextEditingController();
  final _destinoController = TextEditingController();
  final _tempoController = TextEditingController();
  final _observacoesController = TextEditingController();

  String _transporteSelecionado = 'Ônibus';

  final List<String> _opcoesTransporte = [
    'Ônibus', 'Carro', 'A pé', 'Moto', 'Bicicleta',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _origemController.dispose();
    _destinoController.dispose();
    _tempoController.dispose();
    _observacoesController.dispose();
    super.dispose();
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
                  const SizedBox(height: 4),
                  _buildLabel('Nome da rota'),
                  const SizedBox(height: 6),
                  _buildCampoTexto(_nomeController, 'Ex: Casa → IFS'),
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
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9E75),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Criar rota',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
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
          const Text(
            'Criar rota',
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
}
