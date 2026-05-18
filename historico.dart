import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  int _selectedIndex = 3;

  final List<HistoricoItem> items = const [
    HistoricoItem(
      route: 'Casa > IFS',
      timestamp: 'Hoje, 07:42',
      duration: '37 min',
      statusColor: Color(0xFF00B894),
    ),
    HistoricoItem(
      route: 'IFS > Trabalho',
      timestamp: 'Hoje, 13:10',
      duration: '14 min',
      statusColor: Color(0xFF00B894),
    ),
    HistoricoItem(
      route: 'Casa > IFS',
      timestamp: 'Ontem, 07:55',
      duration: '48 min',
      statusColor: Color(0xFFF39C12),
      note: 'acima do normal',
    ),
    HistoricoItem(
      route: 'IFS > Trabalho',
      timestamp: 'Ontem, 13:20',
      duration: '12 min',
      statusColor: Color(0xFF00B894),
    ),
    HistoricoItem(
      route: 'Casa > Shopping Jardins',
      timestamp: '27/03, 18:00',
      duration: '22 min',
      statusColor: Color(0xFF00B894),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF01A05D),
        elevation: 0,
        toolbarHeight: 110,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Histórico',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Março de 2026',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _DateRangeCard(theme: theme),
              const SizedBox(height: 20),
              _SummaryRow(theme: theme),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return _HistoricoCard(item: items[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF01A05D),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Registrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alt_route_outlined),
            activeIcon: Icon(Icons.alt_route),
            label: 'Rotas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }
}

class _DateRangeCard extends StatelessWidget {
  const _DateRangeCard({required this.theme, super.key});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Período',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text(
                      '01/03/2026',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '30/03/2026',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.close,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.theme, super.key});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(
          label: 'Deslocamentos',
          value: '31',
          theme: theme,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          label: 'Tempo total',
          value: '22h',
          theme: theme,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          label: 'Rota principal',
          value: 'Casa > IFS',
          theme: theme,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.theme,
    super.key,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoricoCard extends StatelessWidget {
  const _HistoricoCard({required this.item, super.key});

  final HistoricoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: item.statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.route,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.timestamp,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: item.statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  item.duration,
                  style: TextStyle(
                    color: item.statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (item.note != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                item.note!,
                style: const TextStyle(
                  color: Color(0xFFB25B01),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class HistoricoItem {
  final String route;
  final String timestamp;
  final String duration;
  final Color statusColor;
  final String? note;

  const HistoricoItem({
    required this.route,
    required this.timestamp,
    required this.duration,
    required this.statusColor,
    this.note,
  });
}
