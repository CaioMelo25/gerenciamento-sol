import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/data/database.dart';
import 'package:gerenciamento_sol/providers.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final Lancamento? lancamentoParaEditar;

  const AddTransactionScreen({super.key, this.lancamentoParaEditar});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();
  
  late DateTime _dataSelecionada;
  Categoria? _categoriaSelecionada;
  late String _tipoSelecionado;

  @override
  void initState() {
    super.initState();
    if (widget.lancamentoParaEditar != null) {
      final l = widget.lancamentoParaEditar!;
      _valorController.text = l.valor.toStringAsFixed(2).replaceAll('.', ',');
      _dataSelecionada = l.data;
      _tipoSelecionado = l.tipo;
      _getCategoriaInicial(l.categoriaId);
    } else {
      _dataSelecionada = DateTime.now();
      _tipoSelecionado = 'venda';
    }
    _dataController.text = DateFormat('dd/MM/yyyy').format(_dataSelecionada);
  }
  
  void _getCategoriaInicial(int categoriaId) async {
    final database = ref.read(databaseProvider);
    // Usamos .getSingleOrNull para mais segurança
    final categoria = await (database.select(database.categorias)..where((tbl) => tbl.id.equals(categoriaId))).getSingleOrNull();
    if (mounted) {
      setState(() {
        _categoriaSelecionada = categoria;
      });
    }
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
      lastDate: DateTime.now().add(const Duration(days: 365)), // Permite datas futuras
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
      
      final isEdit = widget.lancamentoParaEditar != null;

      final lancamentoCompanion = LancamentosCompanion(
        id: isEdit ? Value(widget.lancamentoParaEditar!.id) : const Value.absent(),
        categoriaId: Value(_categoriaSelecionada!.id),
        data: Value(_dataSelecionada),
        valor: Value(valor),
        tipo: Value(_tipoSelecionado),
      );

      final future = isEdit
          ? database.atualizarLancamento(lancamentoCompanion)
          : database.adicionarLancamento(lancamentoCompanion);

      future.then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lançamento salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Volta para a tela inicial do app
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);
    final textTheme = Theme.of(context).textTheme;
    final isEdit = widget.lancamentoParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Lançamento' : 'Novo Lançamento'),
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
              decoration: const InputDecoration(hintText: 'R\$ 0,00'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => (v == null || v.isEmpty) ? 'Insira um valor' : null,
            ),
            const SizedBox(height: 16),

            Text('Categoria', style: textTheme.bodyLarge),
            const SizedBox(height: 8),
            FutureBuilder<List<Categoria>>(
              future: database.select(database.categorias).get(),
              builder: (context, snapshot) {
                // ===== INÍCIO DO CÓDIGO DE DIAGNÓSTICO =====
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  print("Categorias carregadas do banco: ${snapshot.data!.length} itens");
                }
                // ===== FIM DO CÓDIGO DE DIAGNÓSTICO =====

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Erro ao carregar categorias: ${snapshot.error}');
                }
                
                // Mostra uma mensagem clara se a lista estiver vazia
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Card(
                    child: ListTile(
                      leading: Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      title: Text('Nenhuma categoria encontrada'),
                      subtitle: Text('Tente reiniciar o app ou limpar os dados.'),
                    ),
                  );
                }

                final categorias = snapshot.data!;
                return DropdownButtonFormField<Categoria>(
                  value: _categoriaSelecionada,
                  decoration: const InputDecoration(
                    hintText: 'Selecione uma categoria',
                  ),
                  items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c.nome))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoriaSelecionada = value;
                    });
                  },
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
              decoration: const InputDecoration(suffixIcon: Icon(Icons.calendar_today_outlined)),
              onTap: _selecionarData,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _salvarLancamento,
              child: Text(isEdit ? 'Salvar Alterações' : 'Adicionar Lançamento'),
            ),
          ],
        ),
      ),
    );
  }
}