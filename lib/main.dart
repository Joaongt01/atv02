import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendamento de Evento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      // Aponta home para Classe AgendamentoEventoTela
      home: const AgendamentoEventoTela(),
    );
  }
}

class AgendamentoEventoTela extends StatefulWidget {
  const AgendamentoEventoTela({super.key});

  @override
  State<AgendamentoEventoTela> createState() => _AgendamentoEventoTelaState();
}

enum frequencia { doisdias, tresdias, quatrodias, cincodias, seisdias }

class _AgendamentoEventoTelaState extends State<AgendamentoEventoTela> {
  void _adicionarAlergia() {
    final alergia = _alergiaController.text.trim();

    // Não permite vazio
    if (alergia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite uma alergia antes de adicionar.')),
      );
      return;
    }

    // Verifica duplicidade ignorando maiúsculas/minúsculas
    final jaExiste = _alergias.any(
      (item) => item.toLowerCase() == alergia.toLowerCase(),
    );

    if (jaExiste) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Essa alergia já foi adicionada.')),
      );
      return;
    }

    setState(() {
      _alergias.add(alergia);
    });

    // Limpa o campo para uma nova entrada
    _alergiaController.clear();

    print('[DEBUG - Alergia] Adicionada: $alergia');
  }

  // --- 1. Valores padrão para Reset ---
  static const double _MinutosPadrao = 60.0;
  static const frequencia _frequenciaPadrao = .tresdias;
  static const bool _termosPadrao = false;
  static const List<String> _tagsDisponiveis = [
    'Vegetariano',
    'Sem glúten',
    'Sem lactose',
    'Vegano',
    'Low carb',
  ];
  static const List<String> _tagsPadrao = [];
  static const bool _lembretePadrao = true;
  static const List<String> _niveisDisponiveis = [
    'Iniciante',
    'Intermediário',
    'Avançado',
  ];
  static const String _nivelPadrao = "Iniciante";
  static const List<String> _objetivosDisponiveis = [
    'Emagrecimento',
    'Hipertrofia',
    'Condicionamento',
  ];
  static const String _objetivoPadrao = "Emagrecimento";
  static const List<String> _alergiasPadrao = [];

  // --- 2. Variáveis de estado ---
  late double _quantidadeMinutos;
  late frequencia _frequenciaSelecionada;
  late bool _termosSelecionado;
  late List<String> _tagSelecionadas;
  late bool _notificacaoAtiva;
  late String _nivelSelecionado;
  late String _objetivoSelecionado;
  late List<String> _alergias;

  final TextEditingController _alergiaController = TextEditingController();

  @override
  void dispose() {
    _alergiaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _resetarValores();
  }

  String _textoFrequencia(frequencia valor) {
    switch (valor) {
      case frequencia.doisdias:
        return '2 dias por semana';

      case frequencia.tresdias:
        return '3 dias por semana';

      case frequencia.quatrodias:
        return '4 dias por semana';

      case frequencia.cincodias:
        return '5 dias por semana';

      case frequencia.seisdias:
        return '6 dias por semana';
    }
  }

  Widget _itemResumo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _resetarValores() {
    setState(() {
      _quantidadeMinutos = _MinutosPadrao;
      _frequenciaSelecionada = _frequenciaPadrao;
      _termosSelecionado = _termosPadrao;
      _tagSelecionadas = List<String>.from(_tagsPadrao);
      _notificacaoAtiva = _lembretePadrao;
      _nivelSelecionado = _nivelPadrao;
      _objetivoSelecionado = _objetivoPadrao;
      _alergias = List<String>.from(_alergiasPadrao);
    });
    print('[DEBUG] Formulário resetado para os valores padrão.');
  }

  void _salvarformulario() {
    // Validação obrigatória dos termos
    if (!_termosSelecionado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos para gerar o plano.'),
        ),
      );
      return;
    }

    _mostrarResumo();
  }

  void _mostrarResumo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barrinha superior
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Seu perfil de treino',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                _itemResumo('Objetivo', _objetivoSelecionado),

                _itemResumo('Nível', _nivelSelecionado),

                _itemResumo(
                  'Restrições alimentares',
                  _tagSelecionadas.isEmpty
                      ? 'Nenhuma'
                      : _tagSelecionadas.join(', '),
                ),

                _itemResumo(
                  'Alergias',
                  _alergias.isEmpty ? 'Nenhuma' : _alergias.join(', '),
                ),

                _itemResumo(
                  'Tempo diário',
                  '${_quantidadeMinutos.round()} minutos',
                ),

                _itemResumo(
                  'Frequência',
                  _textoFrequencia(_frequenciaSelecionada),
                ),

                _itemResumo(
                  'Notificações de água',
                  _notificacaoAtiva ? 'Ativadas' : 'Desativadas',
                ),

                _itemResumo(
                  'Termos',
                  _termosSelecionado ? 'Aceitos' : 'Não aceitos',
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Fechar'),
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
      appBar: AppBar(
        title: const Text('Montador de Treino'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 3. SegmentedButton ---
            Text('OBJETIVO', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: _objetivosDisponiveis.map((objetivo) {
                  return ButtonSegment<String>(
                    value: objetivo,
                    label: Text(objetivo),
                  );
                }).toList(),
                selected: {_objetivoSelecionado},
                onSelectionChanged: (Set<String> selecionado) {
                  setState(() {
                    _objetivoSelecionado = selecionado.first;
                  });
                  print(
                    '[DEBUG - SegmentedButton] Objetivo selecionado: $_objetivoSelecionado',
                  );
                },
                multiSelectionEnabled: false,
              ),
            ),
            const Divider(height: 32),

            // 4. ChoiceChip
            Text(
              'NÍVEL DE EXPERIÊNCIA',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _niveisDisponiveis.map((nivel) {
                final selecionado = _nivelSelecionado == nivel;
                return ChoiceChip(
                  label: Text(nivel),
                  selected: selecionado,
                  onSelected: (selecionado) {
                    if (selecionado) {
                      setState(() {
                        _nivelSelecionado = nivel;
                      });
                      print('[DEBUG - ChoiceChip] Nível selecionado: $nivel');
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 32),

            // --- 5. Chip (FilterChip) --
            Text(
              'Restrições Alimentares',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: _tagsDisponiveis.map((tag) {
                final estaSelecionado = _tagSelecionadas.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: estaSelecionado,
                  onSelected: (bool selecionado) {
                    setState(() {
                      if (selecionado) {
                        _tagSelecionadas.add(tag);
                      } else {
                        _tagSelecionadas.remove(tag);
                      }
                    });
                    print(
                      '[DEBUG - Chip] Tag "$tag" ${selecionado ? "adicionada" : "removida"}. Lista atual: $_tagSelecionadas',
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 32),
            Text('Alergias', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _alergiaController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Nova alergia',
                      hintText: 'Ex.: Amendoim',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      _adicionarAlergia();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _adicionarAlergia,
                  child: const Text('Adicionar'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _alergias.map((alergia) {
                return InputChip(
                  label: Text(alergia),

                  onDeleted: () {
                    setState(() {
                      _alergias.remove(alergia);
                    });

                    print('[DEBUG - Alergia] Removida: $alergia');
                  },
                );
              }).toList(),
            ),

            // 4 --- Slider ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TEMPO DIÁRIO',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${_quantidadeMinutos.round()} minutos',
                  style: const TextStyle(fontWeight: FontWeight(12)),
                ),
              ],
            ),
            Slider(
              value: _quantidadeMinutos,
              min: 15,
              max: 120,
              divisions: 21,
              label: _quantidadeMinutos.round().toString(),
              onChanged: (novoValor) {
                setState(() {
                  _quantidadeMinutos = novoValor;
                });
                print('Tempo diário de treino: ${novoValor.round()}');
              },
            ),
            const Divider(height: 32),

            // --- 5. Radio ---
            Text(
              'FREQUÊNCIA SEMANAL',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            RadioGroup<frequencia>(
              groupValue: _frequenciaSelecionada,
              onChanged: (frequencia? frequencia) {
                setState(() {
                  _frequenciaSelecionada = frequencia!;
                  print('Frequência semanal: $frequencia');
                });
              },
              child: Column(
                children: [
                  ListTile(
                    title: Text('2 Dias por semana'),
                    leading: Radio<frequencia>(value: frequencia.doisdias),
                  ),
                  ListTile(
                    title: Text('3 Dias por semana'),
                    leading: Radio<frequencia>(value: frequencia.tresdias),
                  ),
                  ListTile(
                    title: Text('4 Dias por semana'),
                    leading: Radio<frequencia>(value: frequencia.quatrodias),
                  ),
                  ListTile(
                    title: Text('5 Dias por semana'),
                    leading: Radio<frequencia>(value: frequencia.cincodias),
                  ),
                  ListTile(
                    title: Text('6 Dias por semana'),
                    leading: Radio<frequencia>(value: frequencia.seisdias),
                  ),
                ],
              ),
            ),
            Divider(height: 32),

            // --- 8. SwitchListTile ---
            SwitchListTile(
              title: const Text('Receber notificações de água'),
              value: _notificacaoAtiva,
              onChanged: (bool ativo) {
                setState(() {
                  _notificacaoAtiva = ativo;
                });
                print('Notificação de água alterada para: $ativo');
              },
            ),
            const Divider(height: 32),
            // --- 6. Checkbox ---,
            CheckboxListTile(
              title: const Text("Aceito os termos"),
              value: _termosSelecionado,
              onChanged: (novoValor) {
                setState(() {
                  _termosSelecionado = novoValor ?? false;
                });
                print('Termos selecionados: $novoValor');
              },
            ),
            const Divider(height: 32),

            // -- Botões de Ação Final (cancelar e salvar) --
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _salvarformulario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('GERAR PLANO'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
