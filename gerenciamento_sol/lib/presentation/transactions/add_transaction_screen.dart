import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();
  
  DateTime _dataSelecionada = DateTime.now();
  Categoria? _categoriaSelecionada;
  String _tipoSelecionado = 'venda';

  @override
  void initState() {
    super.initState();
    _dataController.text = DateFormat('dd/MM/yyyy').format(_dataSelecionada);
  }

  @override
  void dispose() {
    _valorController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
        _dataController.text = DateFormat('dd/MM/yyyy').format(_dataSelecionada);
      });
    }
  }

  void _salvarLancamento() {
    if (_formKey.currentState!.validate()) {
      final database = ref.read(databaseProvider);
      final valor = double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0;
      
      final novoLancamento = LancamentosCompanion.insert(
        categoriaId: _categoriaSelecionada!.id,
        data: _dataSelecionada,
        valor: valor,
        tipo: _tipoSelecionado,
      );

      database.adicionarLancamento(novoLancamento).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lançamento salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tipoSelecionado == 'venda' ? 'Nova Entrada' : 'Novo Gasto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'venda', label: Text('Venda'), icon: Icon(Icons.arrow_upward)),
                ButtonSegment(value: 'compra', label: Text('Compra'), icon: Icon(Icons.arrow_downward)),
              ],
              selected: {_tipoSelecionado},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _tipoSelecionado = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 24),

            Text('Valor', style: textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(
                hintText: 'R\$ 0,00',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Por favor, insira um valor';
                if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Número inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),

            Text('Categoria', style: textTheme.bodyLarge),
            const SizedBox(height: 8),
            FutureBuilder<List<Categoria>>(
              future: database.select(database.categorias).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final categorias = snapshot.data!;
                return DropdownButtonFormField<Categoria>(
                  value: _categoriaSelecionada,
                  decoration: const InputDecoration(
                    hintText: 'Selecione uma categoria',
                  ),
                  items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c.nome))).toList(),
                  onChanged: (value) => setState(() => _categoriaSelecionada = value),
                  validator: (value) => value == null ? 'Selecione uma categoria' : null,
                );
              },
            ),
            const SizedBox(height: 16),

            Text('Data', style: textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _dataController,
              readOnly: true,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              onTap: _selecionarData,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _salvarLancamento,
              child: const Text('Adicionar Lançamento'),
            ),
          ],
        ),
      ),
    );
  }
}