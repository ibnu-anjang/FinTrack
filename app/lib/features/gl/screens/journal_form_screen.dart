import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/account.dart';
import '../../../models/journal_entry.dart';
import '../../workspace/providers/workspace_provider.dart';
import '../providers/coa_provider.dart';
import '../providers/journal_provider.dart';
import '../widgets/entry_row_widget.dart';

const _uuid = Uuid();

class JournalFormScreen extends ConsumerStatefulWidget {
  const JournalFormScreen({super.key});

  @override
  ConsumerState<JournalFormScreen> createState() => _JournalFormScreenState();
}

class _JournalFormScreenState extends ConsumerState<JournalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  final _descCtrl = TextEditingController();
  final List<JournalEntry> _entries = [_emptyEntry(), _emptyEntry()];

  static JournalEntry _emptyEntry() => JournalEntry(
        entryId: _uuid.v4(),
        accountRef: '',
        accountCode: '',
        accountName: '',
        amount: 0,
        side: EntrySide.debit,
      );

  // amount dalam Sen
  int get _totalDebit =>
      _entries.where((e) => e.side == EntrySide.debit).fold(0, (s, e) => s + e.amount);
  int get _totalKredit =>
      _entries.where((e) => e.side == EntrySide.kredit).fold(0, (s, e) => s + e.amount);
  bool get _isBalanced => _totalDebit == _totalKredit && _totalDebit > 0;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isBalanced) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Total Debit harus sama dengan Total Kredit'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Setelah form valid, semua baris pasti sudah terisi — tidak perlu filter
    final workspaceId = ref.read(activeWorkspaceProvider) ?? '';
    final validEntries = List<JournalEntry>.from(_entries);
    final ok = await ref.read(journalProvider.notifier).saveJournal(
          workspaceId: workspaceId,
          date: _date,
          description: _descCtrl.text.trim(),
          entries: validEntries,
        );

    if (mounted) {
      if (ok) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jurnal berhasil disimpan'),
            backgroundColor: AppColors.primary,
          ),
        );
      } else {
        final err = ref.read(journalProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$err'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coaAsync = ref.watch(coaListProvider).whenData((list) => list.where((a) => a.isActive).toList());
    final isSaving = ref.watch(journalProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Jurnal'),
        actions: [
          TextButton(
            onPressed: isSaving ? null : _submit,
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text('Simpan',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: coaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (accounts) => _buildForm(accounts),
      ),
    );
  }

  Widget _buildForm(List<Account> accounts) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Tanggal',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text('${_date.day}/${_date.month}/${_date.year}'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Keterangan',
                            prefixIcon: Icon(Icons.notes),
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Keterangan wajib diisi' : null,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Entri Jurnal', style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => setState(() => _entries.add(_emptyEntry())),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah Baris'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  _entries.length,
                  (i) => EntryRowWidget(
                    index: i,
                    entry: _entries[i],
                    accounts: accounts,
                    onChanged: (updated) => setState(() => _entries[i] = updated),
                    onRemove: _entries.length > 2
                        ? () => setState(() => _entries.removeAt(i))
                        : () {},
                  ),
                ),
              ],
            ),
          ),
          _BalanceSummary(
            totalDebit: _totalDebit,
            totalKredit: _totalKredit,
            isBalanced: _isBalanced,
          ),
        ],
      ),
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  final int totalDebit;   // dalam Sen
  final int totalKredit;  // dalam Sen
  final bool isBalanced;

  const _BalanceSummary({
    required this.totalDebit,
    required this.totalKredit,
    required this.isBalanced,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isBalanced
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.error.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Icon(
              isBalanced ? Icons.check_circle : Icons.error_outline,
              color: isBalanced ? AppColors.primary : AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tampilkan dalam Rupiah (Sen / 100)
                  Text('Debit: ${formatRupiah(totalDebit)}',
                      style: const TextStyle(fontSize: 13)),
                  Text('Kredit: ${formatRupiah(totalKredit)}',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
            Text(
              isBalanced ? 'BALANCE' : 'TIDAK BALANCE',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isBalanced ? AppColors.primary : AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
