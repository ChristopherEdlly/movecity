import 'package:flutter/material.dart';

class StartTripScreen extends StatefulWidget {
  const StartTripScreen({super.key});

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  static const Color _primaryGreen = Color(0xFF1D9E75);
  static const Color _background = Color(0xFFF3F3F2);
  static const Color _lightRouteCard = Color(0xFFEAF5E2);

  final TextEditingController _observationController = TextEditingController();
  final List<String> _transportOptions = const [
    'Ônibus',
    'Carro',
    'A pé',
    'Moto',
    'Bicicleta',
  ];

  TimeOfDay _departureTime = const TimeOfDay(hour: 7, minute: 42);
  String _selectedTransport = 'Ônibus';

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: _buildBottomNavigation(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
                children: [
                  _buildStepper(),
                  const SizedBox(height: 14),
                  _buildSelectedRouteCard(),
                  const SizedBox(height: 18),
                  _buildSectionLabel('Horário de saída'),
                  const SizedBox(height: 6),
                  _buildDepartureTimeField(context),
                  const SizedBox(height: 18),
                  _buildSectionLabel('Meio de transporte'),
                  const SizedBox(height: 8),
                  _buildTransportSelector(),
                  const SizedBox(height: 16),
                  _buildSectionLabel('Observação (opcional)'),
                  const SizedBox(height: 7),
                  _buildObservationField(),
                  const SizedBox(height: 20),
                  _buildConfirmButton(),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _primaryGreen,
      padding: EdgeInsets.fromLTRB(
        4,
        MediaQuery.of(context).padding.top + 8,
        20,
        24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
            tooltip: 'Voltar',
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
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
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

  Widget _buildStepper() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          _StepIndicator(number: '✓', label: 'Rota', state: _StepState.done),
          Expanded(child: _StepDivider(isActive: true)),
          _StepIndicator(number: '2', label: 'Saída', state: _StepState.active),
          Expanded(child: _StepDivider()),
          _StepIndicator(number: '3', label: 'Chegada'),
        ],
      ),
    );
  }

  Widget _buildSelectedRouteCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _lightRouteCard,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFA3CC59), width: 1.2),
      ),
      child: const Row(
        children: [
          CircleAvatar(radius: 7, backgroundColor: _primaryGreen),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Casa ➜ IFS',
                  style: TextStyle(
                    color: Color(0xFF13694F),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
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

  Widget _buildDepartureTimeField(BuildContext context) {
    final formattedTime =
        '${_departureTime.hour.toString().padLeft(2, '0')}:${_departureTime.minute.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _pickDepartureTime(context),
        borderRadius: BorderRadius.circular(11),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: _primaryGreen, width: 1.7),
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
                formattedTime,
                style: const TextStyle(
                  color: _primaryGreen,
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

  Future<void> _pickDepartureTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _departureTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryGreen,
              onPrimary: Colors.white,
              onSurface: Color(0xFF202221),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) {
      return;
    }

    setState(() {
      _departureTime = pickedTime;
    });
  }

  Widget _buildTransportSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final transport in _transportOptions)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(transport),
                selected: _selectedTransport == transport,
                onSelected: (_) {
                  setState(() {
                    _selectedTransport = transport;
                  });
                },
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _selectedTransport == transport
                      ? Colors.white
                      : const Color(0xFF777777),
                ),
                selectedColor: _primaryGreen,
                backgroundColor: Colors.white,
                showCheckmark: false,
                side: BorderSide(
                  color: _selectedTransport == transport
                      ? _primaryGreen
                      : const Color(0xFFE0E0DD),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildObservationField() {
    return TextField(
      controller: _observationController,
      minLines: 1,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Observação (opcional)',
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryGreen, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          elevation: 7,
          shadowColor: _primaryGreen.withValues(alpha: 0.28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Confirmar saída',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: _primaryGreen,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Registrar',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Rotas'),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          label: 'Histórico',
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF777777),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

enum _StepState { inactive, active, done }

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.number,
    required this.label,
    this.state = _StepState.inactive,
  });

  final String number;
  final String label;
  final _StepState state;

  static const Color _primaryGreen = Color(0xFF1D9E75);

  @override
  Widget build(BuildContext context) {
    final isActive = state == _StepState.active || state == _StepState.done;
    final color = isActive ? _primaryGreen : const Color(0xFFCFCFCF);

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          label,
          style: TextStyle(
            color: isActive ? _primaryGreen : const Color(0xFF909090),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  const _StepDivider({this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 24),
      color: isActive ? const Color(0xFF1D9E75) : const Color(0xFFDCDCDC),
    );
  }
}
