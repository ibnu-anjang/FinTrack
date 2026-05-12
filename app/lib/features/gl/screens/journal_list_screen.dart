import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/journal_entry.dart';
import '../../../models/transaction.dart';
import '../../workspace/providers/workspace_provider.dart';
import '../providers/journal_provider.dart';

class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalsAsync = ref.watch(journalListProvider);
    final workspaceId = ref.watch(activeWorkspaceProvider);
    if (workspaceId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Jurnal')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/gl/journal/new'),
        icon: const Icon(Icons.add),
        label: const Text('Buat Jurnal'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: journalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (journals) {
          if (journals.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('Belum ada jurnal', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: journals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _JournalCard(
              transaction: journals[i],
              workspaceId: workspaceId,
            ),
          );
        },
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final Transaction transaction;
  final String workspaceId;
  const _JournalCard({required this.transaction, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      transaction.description,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusChip(isPosted: transaction.isPosted),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}  •  ${transaction.sourceModule}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                formatRupiah(transaction.totalAmount),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _JournalDetailSheet(transaction: transaction, workspaceId: workspaceId),
    );
  }
}

class _JournalDetailSheet extends ConsumerWidget {
  final Transaction transaction;
  final String workspaceId;
  const _JournalDetailSheet({required this.transaction, required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef innerRef) {
    final entriesAsync = innerRef.watch(journalEntriesProvider(workspaceId, transaction.transactionId));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, ctrl) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: Text(transaction.description,
                        style: Theme.of(context).textTheme.titleLarge)),
                _StatusChip(isPosted: transaction.isPosted),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 24),
            const Row(children: [
              Expanded(flex: 3, child: Text('Akun', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              Expanded(flex: 2, child: Text('Debit', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              Expanded(flex: 2, child: Text('Kredit', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
            ]),
            const SizedBox(height: 8),
            Expanded(
              child: entriesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (entries) => ListView(
                  controller: ctrl,
                  children: [
                    ...entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(children: [
                            Expanded(
                                flex: 3,
                                child: Text('${e.accountCode} ${e.accountName}',
                                    style: const TextStyle(fontSize: 13))),
                            Expanded(
                                flex: 2,
                                child: Text(
                                    e.side == EntrySide.debit ? formatRupiah(e.amount) : '',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 13))),
                            Expanded(
                                flex: 2,
                                child: Text(
                                    e.side == EntrySide.kredit ? formatRupiah(e.amount) : '',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 13))),
                          ]),
                        )),
                    const Divider(),
                    Row(children: [
                      const Expanded(flex: 3, child: Text('Total', style: TextStyle(fontWeight: FontWeight.w700))),
                      Expanded(
                          flex: 2,
                          child: Text(
                            formatRupiah(entries.where((e) => e.side == EntrySide.debit).fold(0, (s, e) => s + e.amount)),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            formatRupiah(entries.where((e) => e.side == EntrySide.kredit).fold(0, (s, e) => s + e.amount)),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )),
                    ]),
                    const SizedBox(height: 12),
                    if (!transaction.isPosted)
                      ElevatedButton.icon(
                        onPressed: () async {
                          await innerRef.read(journalProvider.notifier).postJournal(workspaceId, transaction.transactionId);
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Posting Jurnal'),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () async {
                          await innerRef.read(journalProvider.notifier).reverseJournal(workspaceId, transaction, entries);
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.undo),
                        label: const Text('Buat Pembalikan'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isPosted;
  const _StatusChip({required this.isPosted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPosted
            ? AppColors.primary.withValues(alpha: 0.12)
            : Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPosted ? 'Posted' : 'Draft',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPosted ? AppColors.primary : Colors.orange.shade700,
        ),
      ),
    );
  }
}
