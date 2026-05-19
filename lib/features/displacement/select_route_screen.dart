import 'package:flutter/material.dart';

class SelectRouteScreen extends StatefulWidget {
  const SelectRouteScreen({super.key});

  @override
  State<SelectRouteScreen> createState() => _SelectRouteScreenState();
}

class _SelectRouteScreenState extends State<SelectRouteScreen> {
  static const Color _primaryGreen = Color(0xFF1D9E75);
  static const Color _background = Color(0xFFF3F3F2);

  final TextEditingController _searchController = TextEditingController();
  int _selectedRouteIndex = 0;
  String _searchTerm = '';

  final List<_RouteOption> _routes = const [
    _RouteOption(
      name: 'Casa ➜ IFS',
      details: 'Ônibus · ~35 min',
      uses: '23 usos',
      color: Color(0xFF1D9E75),
    ),
    _RouteOption(
      name: 'IFS ➜ Trabalho',
      details: 'A pé · ~12 min',
      uses: '18 usos',
      color: Color(0xFFBA7517),
    ),
    _RouteOption(
      name: 'Casa ➜ Shopping Jardins',
      details: 'Carro · ~20 min',
      uses: '7 usos',
      color: Color(0xFF3E7DD6),
    ),
    _RouteOption(
      name: 'Trabalho ➜ Academia',
      details: 'A pé · ~8 min',
      uses: '12 usos',
      color: Color(0xFF8F62D9),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRoutes = _filteredRoutes;

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
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
                children: [
                  _buildStepper(),
                  const SizedBox(height: 20),
                  _buildSearchField(),
                  const SizedBox(height: 22),
                  const Text(
                    'Suas rotas',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF202221),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (filteredRoutes.isEmpty)
                    _buildEmptyState()
                  else
                    ...filteredRoutes.map(
                      (indexedRoute) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _RouteCard(
                          route: indexedRoute.route,
                          isSelected: indexedRoute.index == _selectedRouteIndex,
                          onTap: () {
                            setState(() {
                              _selectedRouteIndex = indexedRoute.index;
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: _primaryGreen.withValues(alpha: 0.28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Confirmar rota',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_IndexedRoute> get _filteredRoutes {
    if (_searchTerm.trim().isEmpty) {
      return [
        for (var i = 0; i < _routes.length; i++)
          _IndexedRoute(index: i, route: _routes[i]),
      ];
    }

    final normalizedTerm = _normalize(_searchTerm);
    return [
      for (var i = 0; i < _routes.length; i++)
        if (_normalize(_routes[i].name).contains(normalizedTerm))
          _IndexedRoute(index: i, route: _routes[i]),
    ];
  }

  String _normalize(String value) {
    return value.toLowerCase().replaceAll('á', 'a').replaceAll('é', 'e');
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        8,
        MediaQuery.of(context).padding.top + 8,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        color: _primaryGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Qual rota você vai usar?',
                    style: TextStyle(fontSize: 14, color: Color(0xFFC7F0DF)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: const Row(
        children: [
          _StepIndicator(number: '1', label: 'Rota', isActive: true),
          Expanded(child: _StepDivider()),
          _StepIndicator(number: '2', label: 'Saída'),
          Expanded(child: _StepDivider()),
          _StepIndicator(number: '3', label: 'Chegada'),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchTerm = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Buscar rota...',
        hintStyle: const TextStyle(color: Color(0xFF9D9D9D), fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF8A8A8A)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE6E6E3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _primaryGreen, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6E3)),
      ),
      child: const Center(
        child: Text(
          'Nenhuma rota encontrada',
          style: TextStyle(color: Color(0xFF777777), fontSize: 13),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.list_outlined),
          label: 'Rotas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          label: 'Histórico',
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  final _RouteOption route;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _primaryGreen = Color(0xFF1D9E75);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? _primaryGreen : const Color(0xFFEAEAE7),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: route.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202221),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      route.details,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    route.uses,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF777777),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 9),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? _primaryGreen : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? _primaryGreen
                            : const Color(0xFFC9C9C9),
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 15, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.number,
    required this.label,
    this.isActive = false,
  });

  final String number;
  final String label;
  final bool isActive;

  static const Color _primaryGreen = Color(0xFF1D9E75);

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _primaryGreen : const Color(0xFFB5B5B5);

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? _primaryGreen : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isActive ? Colors.white : color,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  const _StepDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 22),
      color: const Color(0xFFD8D8D6),
    );
  }
}

class _RouteOption {
  const _RouteOption({
    required this.name,
    required this.details,
    required this.uses,
    required this.color,
  });

  final String name;
  final String details;
  final String uses;
  final Color color;
}

class _IndexedRoute {
  const _IndexedRoute({required this.index, required this.route});

  final int index;
  final _RouteOption route;
}
