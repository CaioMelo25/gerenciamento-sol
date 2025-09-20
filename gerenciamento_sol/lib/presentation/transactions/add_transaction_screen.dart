import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  
  DateTime _dataSelecionada = DateTime.now();
  Categoria? _categoriaSelecionada;
  String _tipoSelecionado = 'venda';   

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
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
          const SnackBar(content: Text('Lançamento salvo com sucesso!')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Lançamento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
                prefixIcon: Icon(Icons.monetization_on_outlined),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um valor';
                }
                if (double.tryParse(value.replaceAll(',', '.')) == null) {
                  return 'Por favor, insira um número válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            FutureBuilder<List<Categoria>>(
              future: database.select(database.categorias).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final categorias = snapshot.data!;
                return DropdownButtonFormField<Categoria>(
                  value: _categoriaSelecionada,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: categorias.map((categoria) {
                    return DropdownMenuItem(
                      value: categoria,
                      child: Text(categoria.nome),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoriaSelecionada = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Por favor, selecione uma categoria' : null,
                );
              },
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _salvarLancamento,
              icon: const Icon(Icons.check),
              label: const Text('Salvar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}