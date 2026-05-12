import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/account.dart';
import '../../../models/journal_entry.dart';
import '../../../core/theme/app_theme.dart';

class EntryRowWidget extends StatefulWidget {
  final int index;
  final JournalEntry entry;
  final List<Account> accounts;
  final ValueChanged<JournalEntry> onChanged;
  final VoidCallback onRemove;

  const EntryRowWidget({
    super.key,
    required this.index,
    required this.entry,
    required this.accounts,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<EntryRowWidget> createState() => _EntryRowWidgetState();
}

class _EntryRowWidgetState extends State<EntryRowWidget> {
  late final TextEditingController _amountCtrl;
  final _dropdownKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    final displayAmount = widget.entry.amount == 0 ? '' : (widget.entry.amount ~/ 100).toString();
    _amountCtrl = TextEditingController(text: displayAmount);
  }

  @override
  void didUpdateWidget(EntryRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.accountCode != widget.entry.accountCode) {
      final newCode = widget.entry.accountCode.isEmpty ? null : widget.entry.accountCode;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _dropdownKey.currentState?.didChange(newCode);
      });
    }
    if (oldWidget.entry.amount != widget.entry.amount) {
      final newText = widget.entry.amount == 0 ? '' : (widget.entry.amount ~/ 100).toString();
      if (_amountCtrl.text != newText) {
        _amountCtrl.text = newText;
        _amountCtrl.selection = TextSelection.collapsed(offset: newText.length);
      }
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text('Baris ${widget.index + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: AppColors.error),
                  onPressed: widget.onRemove,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: _dropdownKey,
              isExpanded: true,
              initialValue: widget.entry.accountCode.isEmpty ? null : widget.entry.accountCode,
              decoration: const InputDecoration(labelText: 'Akun', isDense: true),
              items: widget.accounts
                  .map((a) => DropdownMenuItem(
                        value: a.accountCode,
                        child: Text('${a.accountCode} — ${a.name}',
                            overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              validator: (v) => (v == null || v.isEmpty) ? 'Pilih akun' : null,
              onChanged: (code) {
                if (code == null) return;
                final acc = widget.accounts.firstWhere((a) => a.accountCode == code);
                widget.onChanged(widget.entry.copyWith(
                  accountRef: 'accounts/${acc.accountCode}',
                  accountCode: acc.accountCode,
                  accountName: acc.name,
                ));
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<EntrySide>(
                    segments: const [
                      ButtonSegment(value: EntrySide.debit, label: Text('Debit')),
                      ButtonSegment(value: EntrySide.kredit, label: Text('Kredit')),
                    ],
                    selected: {widget.entry.side},
                    onSelectionChanged: (s) => widget.onChanged(widget.entry.copyWith(side: s.first)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _amountCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah (Rp)',
                      isDense: true,
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => (v == null || v.isEmpty || (int.tryParse(v) ?? 0) == 0)
                        ? 'Isi jumlah'
                        : null,
                    // Input dalam Rupiah, konversi ke Sen (* 100) sebelum simpan
                    onChanged: (v) => widget.onChanged(
                        widget.entry.copyWith(amount: (int.tryParse(v) ?? 0) * 100)),
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
