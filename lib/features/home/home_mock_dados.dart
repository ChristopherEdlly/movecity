import 'home_dados.dart';

// Dados temporários que simulam o que o backend vai retornar.
// Para testar cada cenário, troque a linha em home_screen.dart:
//   static final _dados = HomeMockDados.novoUsuario;
//   static final _dados = HomeMockDados.usuarioNormal;
//   static final _dados = HomeMockDados.usuarioComSugestao;

class HomeMockDados {
  // Novo usuário: ainda não cadastrou nenhuma rota.
  static final novoUsuario = DadosHome(
    nomeUsuario: '',
    deslocamentosHoje: 0,
    tempoTotalHoje: '',
    rotas: [],
    graficoSemana: [],
    diaAtualIndex: 0,
  );

  // Usuário normal: tem rotas cadastradas e já fez deslocamentos hoje.
  static final usuarioNormal = DadosHome(
    nomeUsuario: 'Chris',
    deslocamentosHoje: 2,
    tempoTotalHoje: '1h 14min',
    rotas: [
      Rota(nome: 'Casa → IFS', ultimaVez: 'Última vez: hoje · 37 min', isPrincipal: true),
      Rota(nome: 'IFS → Trabalho', ultimaVez: 'Última vez: sex · 14 min', isPrincipal: false),
    ],
    graficoSemana: [34, 27, 0, 44, 25, 0, 0],
    diaAtualIndex: 4,
    dica: 'Dica: às quartas, a Av. Tancredo Neves costuma ter +12 min de trânsito.',
  );

  // Usuário com sugestão: tem rotas, mas o backend mandou uma sugestão ativa.
  static final usuarioComSugestao = DadosHome(
    nomeUsuario: 'Lucas',
    deslocamentosHoje: 0,
    tempoTotalHoje: '— min',
    sugestao: SugestaoRota(
      rota: 'Casa → IFS',
      transporte: 'Ônibus',
      tempoEstimado: '~35 min',
      saidaIdeal: '07:20',
    ),
    alertaTransito: AlertaTransito(
      titulo: 'Trânsito elevado na Tancredo Neves',
      mensagem: 'Considere sair 10 min mais cedo hoje.',
    ),
    rotas: [
      Rota(nome: 'Casa → IFS', ultimaVez: 'Ontem · 37 min', isPrincipal: true),
      Rota(nome: 'IFS → Trabalho', ultimaVez: 'Sexta · 14 min', isPrincipal: false),
    ],
    graficoSemana: [0, 0, 0, 0, 0, 0, 0],
    diaAtualIndex: 0,
  );
}
