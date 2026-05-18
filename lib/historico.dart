import 'package:flutter/material.dart';

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _HistoricoHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _DateFilterCard(),
                  const SizedBox(height: 16),
                  _SummaryCards(),
                  const SizedBox(height: 16),
                  Expanded(child: _HistoricoList()),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_outlined), label: 'Registrar'),
          BottomNavigationBarItem(icon: Icon(Icons.route_outlined), label: 'Rotas'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
        ],
      ),
    );
  }
}

class _HistoricoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Histórico',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Março de 2026',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateFilterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.black54),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                '01/03/2026  →  30/03/2026',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _StatCard(label: 'Deslocamentos', value: '31')),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: 'Tempo total', value: '22h')),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: 'Rota principal', value: 'Casa > IFS')),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoricoList extends StatelessWidget {
  final List<_HistoricoEntry> entries = const [
    _HistoricoEntry(
      title: 'Casa > IFS',
      subtitle: 'Hoje, 07:42',
      duration: '37 min',
      color: Color(0xFF2E7D32),
      extraText: '',
    ),
    _HistoricoEntry(
      title: 'IFS > Trabalho',
      subtitle: 'Hoje, 13:10',
      duration: '14 min',
      color: Color(0xFF2E7D32),
      extraText: '',
    ),
    _HistoricoEntry(
      title: 'Casa > IFS',
      subtitle: 'Ontem, 07:55',
      duration: '48 min',
      color: Color(0xFFF57C00),
      extraText: 'acima do normal',
    ),
    _HistoricoEntry(
      title: 'IFS > Trabalho',
      subtitle: 'Ontem, 13:20',
      duration: '12 min',
      color: Color(0xFF2E7D32),
      extraText: '',
    ),
    _HistoricoEntry(
      title: 'Casa > Shopping Jardins',
      subtitle: '27/03, 18:00',
      duration: '22 min',
      color: Color(0xFF2E7D32),
      extraText: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = entries[index];
        return _HistoricoCard(entry: item);
      },
    );
  }
}

class _HistoricoEntry {
  final String title;
  final String subtitle;
  final String duration;
  final Color color;
  final String extraText;

  const _HistoricoEntry({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.color,
    required this.extraText,
  });
}

class _HistoricoCard extends StatelessWidget {
  final _HistoricoEntry entry;

  const _HistoricoCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: entry.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                if (entry.extraText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    entry.extraText,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ],
            ),
          ),
          Text(
            entry.duration,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: entry.color,
            ),
          ),
        ],
      ),
    );
  }
}
