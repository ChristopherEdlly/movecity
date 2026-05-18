import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HistoricoScreen(),
    );
  }
}

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),

      body: Column(
        children: [

          // HEADER VERDE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 16,
              right: 16,
              bottom: 18,
            ),
            decoration: const BoxDecoration(
              color: Color(0xff13A66A),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // TITULO
                const Text(
                  "Histórico",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 4),

                // MES
                const Text(
                  "Março de 2026",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 18),

                // CAMPO DATA
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    children: [

                      Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Text(
                          "01/03/2026  →  30/03/2026",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff444444),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.close,
                        size: 17,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // CARD ESTATISTICAS
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Row(
                    children: [

                      // ITEM
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Deslocamentos",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff8C8C8C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "31",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff222222),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 38,
                        color: Color(0xffEAEAEA),
                      ),

                      const SizedBox(width: 14),

                      // ITEM
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Tempo total",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff8C8C8C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "22h",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff222222),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 38,
                        color: Color(0xffEAEAEA),
                      ),

                      const SizedBox(width: 14),

                      // ITEM
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Rota principal",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff8C8C8C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "Casa→IFS",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff222222),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // LISTA
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 10,
              ),
              children: const [

                HistoricoCard(
                  title: "Casa → IFS",
                  subtitle: "Hoje, 07:42",
                  time: "37 min",
                  green: true,
                ),

                HistoricoCard(
                  title: "IFS → Trabalho",
                  subtitle: "Hoje, 13:10",
                  time: "14 min",
                  green: true,
                ),

                HistoricoCard(
                  title: "Casa → IFS",
                  subtitle: "Ontem, 07:55",
                  time: "48 min\nacima do normal",
                  green: false,
                ),

                HistoricoCard(
                  title: "IFS → Trabalho",
                  subtitle: "Ontem, 13:20",
                  time: "12 min",
                  green: true,
                ),

                HistoricoCard(
                  title: "Casa → Shopping Jardins",
                  subtitle: "27/03, 18:00",
                  time: "22 min",
                  green: true,
                ),
              ],
            ),
          ),
        ],
      ),

      // BOTTOM BAR
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xffEAEAEA),
            ),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            navItem(
              icon: Icons.home_outlined,
              label: "Início",
              active: false,
            ),

            navItem(
              icon: Icons.add_circle_outline,
              label: "Registrar",
              active: false,
            ),

            navItem(
              icon: Icons.menu,
              label: "Rotas",
              active: false,
            ),

            navItem(
              icon: Icons.history,
              label: "Histórico",
              active: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required bool active,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          icon,
          size: 22,
          color: active
              ? const Color(0xff13A66A)
              : const Color(0xff8F8F8F),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: active
                ? const Color(0xff13A66A)
                : const Color(0xff8F8F8F),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class HistoricoCard extends StatelessWidget {

  final String title;
  final String subtitle;
  final String time;
  final bool green;

  const HistoricoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.green,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),

      child: Row(
        children: [

          // BOLINHA
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: green
                  ? const Color(0xff13A66A)
                  : const Color(0xffD1841E),
            ),
          ),

          const SizedBox(width: 12),

          // TEXTOS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff333333),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff9C9C9C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // TEMPO
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: green ? 14 : 10,
              vertical: green ? 7 : 5,
            ),

            decoration: BoxDecoration(
              color: green
                  ? const Color(0xffE4F5E8)
                  : const Color(0xffFFE9DA),

              borderRadius: BorderRadius.circular(8),
            ),

            child: Text(
              time,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: green ? 11 : 10,
                height: 1.2,
                color: green
                    ? const Color(0xff5D9C5E)
                    : const Color(0xffD17A3C),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.chevron_right,
            color: Color(0xffBDBDBD),
            size: 20,
          ),
        ],
      ),
    );
  }
}