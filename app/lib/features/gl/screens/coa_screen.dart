import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/account.dart';
import '../../../models/account_group.dart';
import '../../workspace/providers/workspace_provider.dart';
import '../providers/account_group_provider.dart';
import '../providers/coa_provider.dart';

class CoaScreen extends ConsumerWidget {
  const CoaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coaAsync = ref.watch(coaListProvider);
    final groupsAsync = ref.watch(accountGroupsProvider);
    final workspaceId = ref.watch(activeWorkspaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart of Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Kelola kategori',
            onPressed: workspaceId == null
                ? null
                : () => _showManageGroupsDialog(context, ref, workspaceId),
          ),
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: 'Seed akun default',
            onPressed: workspaceId == null
                ? null
                : () async {
                    await ref
                        .read(coaProvider.notifier)
                        .seedDefaultCoa(workspaceId);
                    await ref
                        .read(accountGroupProvider.notifier)
                        .seedDefaultGroups(workspaceId);
                  },
          ),
        ],
      ),
      floatingActionButton: workspaceId == null
          ? null
          : FloatingActionButton(
              onPressed: () => _showAccountDialog(
                  context, ref, workspaceId,
                  groups: groupsAsync.when(data: (g) => g, loading: () => kDefaultGroups(), error: (_, __) => kDefaultGroups()),
                  existing: null),
              tooltip: 'Tambah akun',
              child: const Icon(Icons.add),
            ),
      body: coaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (accounts) {
          final groups = groupsAsync.when(data: (g) => g, loading: () => <AccountGroup>[], error: (_, __) => <AccountGroup>[]);

          if (accounts.isEmpty && groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_tree_outlined,
                      size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('Belum ada akun'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: workspaceId == null
                        ? null
                        : () async {
                            await ref
                                .read(coaProvider.notifier)
                                .seedDefaultCoa(workspaceId);
                            await ref
                                .read(accountGroupProvider.notifier)
                                .seedDefaultGroups(workspaceId);
                          },
                    icon: const Icon(Icons.add),
                    label: const Text('Muat Akun Default'),
                  ),
                ],
              ),
            );
          }

          // Kelompokkan akun berdasarkan group id (atau fallback ke category)
          final grouped = <String, List<Account>>{};
          for (final a in accounts) {
            final key = a.group ?? a.category.name;
            grouped.putIfAbsent(key, () => []).add(a);
          }

          // Urutkan groups berdasarkan order, tampilkan juga grup yang ada akun tapi tidak ada di groups list
          final sortedGroups = <AccountGroup>[...groups];
          // Tambah fallback untuk akun dengan grup yang tidak ada di Firestore
          final knownIds = groups.map((g) => g.id).toSet();
          for (final key in grouped.keys) {
            if (!knownIds.contains(key)) {
              sortedGroups.add(AccountGroup(
                id: key,
                name: _fallbackGroupName(key),
                accountType: _fallbackAccountType(key),
                order: 99,
              ));
            }
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            children: sortedGroups
                .where((g) => grouped.containsKey(g.id))
                .map((g) => _GroupSection(
                      group: g,
                      accounts: grouped[g.id] ?? [],
                      onTapAccount: (a) => _showAccountDialog(
                        context, ref, workspaceId ?? '',
                        groups: groups,
                        existing: a,
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  String _fallbackGroupName(String key) => switch (key) {
        'asset' => '1. ASET',
        'liability' => '2. KEWAJIBAN',
        'equity' => '3. EKUITAS',
        'revenue' => '4. PENDAPATAN',
        'expense' => '5. BEBAN',
        _ => key,
      };

  AccountCategory _fallbackAccountType(String key) => switch (key) {
        'liability' => AccountCategory.liability,
        'equity' => AccountCategory.equity,
        'revenue' => AccountCategory.revenue,
        'expense' => AccountCategory.expense,
        _ => AccountCategory.asset,
      };

  // ── Dialog edit/tambah akun ─────────────────────────────────────────────────

  Future<void> _showAccountDialog(
    BuildContext context,
    WidgetRef ref,
    String workspaceId, {
    required List<AccountGroup> groups,
    required Account? existing,
  }) async {
    final isEdit = existing != null;
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController(text: existing?.accountCode ?? '');
    final nameCtrl = TextEditingController(text: existing?.name ?? '');

    // Tentukan grup awal — pastikan nilainya ada di daftar grup
    final firstGroupId = groups.isNotEmpty ? groups.first.id : null;
    final candidateId = existing?.group ?? existing?.category.name;
    final initialGroupId = (candidateId != null && groups.any((g) => g.id == candidateId))
        ? candidateId
        : (firstGroupId ?? 'asset');
    final initialGroup = groups.firstWhere((g) => g.id == initialGroupId, orElse: () => groups.isNotEmpty ? groups.first : AccountGroup(id: 'asset', name: 'Aset', accountType: AccountCategory.asset, order: 0));
    var selectedGroupId = initialGroupId;
    var selectedCategory = existing?.category ?? initialGroup.accountType;
    var selectedNormalBalance = existing?.normalBalance ??
        (selectedCategory == AccountCategory.asset || selectedCategory == AccountCategory.expense
            ? NormalBalance.debit
            : NormalBalance.kredit);
    var isActive = existing?.isActive ?? true;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
            title: Text(isEdit ? 'Edit Akun' : 'Tambah Akun'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: codeCtrl,
                      enabled: !isEdit,
                      decoration: const InputDecoration(
                        labelText: 'Kode Akun',
                        hintText: 'mis. 1150',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Kode akun wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nama Akun',
                        hintText: 'mis. Piutang Karyawan',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nama akun wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Dropdown grup — pakai groups dari Firestore
                    if (groups.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue: selectedGroupId,
                        decoration: const InputDecoration(labelText: 'Kategori / Grup'),
                        items: groups
                            .map((g) => DropdownMenuItem(
                                  value: g.id,
                                  child: Text(g.name),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          final g = groups.firstWhere((g) => g.id == v,
                              orElse: () => groups.first);
                          setState(() {
                            selectedGroupId = v;
                            selectedCategory = g.accountType;
                            selectedNormalBalance = switch (g.accountType) {
                              AccountCategory.asset ||
                              AccountCategory.expense =>
                                NormalBalance.debit,
                              _ => NormalBalance.kredit,
                            };
                          });
                        },
                      )
                    else
                      DropdownButtonFormField<AccountCategory>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(labelText: 'Kategori'),
                        items: AccountCategory.values
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(_categoryLabel(c)),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() {
                            selectedCategory = v;
                            selectedGroupId = v.name;
                            selectedNormalBalance = switch (v) {
                              AccountCategory.asset ||
                              AccountCategory.expense =>
                                NormalBalance.debit,
                              _ => NormalBalance.kredit,
                            };
                          });
                        },
                      ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<NormalBalance>(
                      initialValue: selectedNormalBalance,
                      decoration: const InputDecoration(labelText: 'Saldo Normal'),
                      items: const [
                        DropdownMenuItem(
                            value: NormalBalance.debit, child: Text('Debit')),
                        DropdownMenuItem(
                            value: NormalBalance.kredit, child: Text('Kredit')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => selectedNormalBalance = v);
                      },
                    ),
                    if (isEdit) ...[
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Aktif'),
                        value: isActive,
                        onChanged: (v) => setState(() => isActive = v),
                        activeThumbColor: AppColors.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              if (isEdit)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () async {
                    final confirm = await _confirmDelete(ctx, existing.name);
                    if (!confirm) return;
                    if (ctx.mounted) Navigator.pop(ctx);
                    await ref
                        .read(coaProvider.notifier)
                        .deleteAccount(workspaceId, existing.id);
                  },
                  child: const Text('Hapus'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  final code = codeCtrl.text.trim();
                  final account = Account(
                    id: isEdit ? existing.id : code,
                    accountCode: isEdit ? existing.accountCode : code,
                    name: nameCtrl.text.trim(),
                    category: selectedCategory,
                    normalBalance: selectedNormalBalance,
                    isActive: isActive,
                    group: selectedGroupId,
                  );
                  Navigator.pop(ctx);
                  if (isEdit) {
                    await ref
                        .read(coaProvider.notifier)
                        .updateAccount(workspaceId, account);
                  } else {
                    await ref
                        .read(coaProvider.notifier)
                        .addAccount(workspaceId, account);
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
      ),
    );
  }

  // ── Dialog kelola grup ──────────────────────────────────────────────────────

  Future<void> _showManageGroupsDialog(
    BuildContext context,
    WidgetRef ref,
    String workspaceId,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => _ManageGroupsDialog(
        workspaceId: workspaceId,
        ref: ref,
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus Akun'),
            content: Text(
                'Hapus akun "$name"? Tindakan ini tidak bisa dibatalkan.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  static String _categoryLabel(AccountCategory cat) => switch (cat) {
        AccountCategory.asset => '1. ASET',
        AccountCategory.liability => '2. KEWAJIBAN',
        AccountCategory.equity => '3. EKUITAS',
        AccountCategory.revenue => '4. PENDAPATAN',
        AccountCategory.expense => '5. BEBAN',
      };
}

// ── Dialog kelola grup (StatefulWidget terpisah) ────────────────────────────

class _ManageGroupsDialog extends ConsumerStatefulWidget {
  final String workspaceId;
  final WidgetRef ref;
  const _ManageGroupsDialog({required this.workspaceId, required this.ref});

  @override
  ConsumerState<_ManageGroupsDialog> createState() =>
      _ManageGroupsDialogState();
}

class _ManageGroupsDialogState extends ConsumerState<_ManageGroupsDialog> {
  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(accountGroupsProvider);

    return AlertDialog(
      title: const Text('Kelola Kategori'),
      content: SizedBox(
        width: double.maxFinite,
        child: groupsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (groups) => groups.isEmpty
              ? const Text('Belum ada kategori.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  itemBuilder: (_, i) {
                    final g = groups[i];
                    return ListTile(
                      dense: true,
                      title: Text(g.name),
                      subtitle: Text(_accountTypeLabel(g.accountType),
                          style: const TextStyle(fontSize: 11)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () =>
                                _showGroupForm(context, g),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            onPressed: () async {
                              final ok = await _confirmDeleteGroup(context, g.name);
                              if (ok) {
                                await ref
                                    .read(accountGroupProvider.notifier)
                                    .deleteGroup(widget.workspaceId, g.id);
                              }
                            },
                            tooltip: 'Hapus',
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _showGroupForm(context, null),
          child: const Text('+ Tambah Kategori'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  Future<void> _showGroupForm(BuildContext context, AccountGroup? existing) async {
    final isEdit = existing != null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final formKey = GlobalKey<FormState>();
    var selectedType = existing?.accountType ?? AccountCategory.asset;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(isEdit ? 'Edit Kategori' : 'Tambah Kategori'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kategori',
                    hintText: 'mis. Aset Lancar',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AccountCategory>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(labelText: 'Tipe Akuntansi'),
                  items: AccountCategory.values
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(_accountTypeLabel(c)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => selectedType = v);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final name = nameCtrl.text.trim();
                final id = isEdit
                    ? existing.id
                    : name.toLowerCase().replaceAll(' ', '_');
                final group = AccountGroup(
                  id: id,
                  name: name,
                  accountType: selectedType,
                  order: existing?.order ?? 99,
                );
                Navigator.pop(ctx);
                if (isEdit) {
                  await ref
                      .read(accountGroupProvider.notifier)
                      .updateGroup(widget.workspaceId, group);
                } else {
                  await ref
                      .read(accountGroupProvider.notifier)
                      .addGroup(widget.workspaceId, group);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDeleteGroup(BuildContext context, String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus Kategori'),
            content: Text(
                'Hapus kategori "$name"? Akun di kategori ini tidak ikut terhapus.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal')),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _accountTypeLabel(AccountCategory cat) => switch (cat) {
        AccountCategory.asset => 'Aset',
        AccountCategory.liability => 'Kewajiban',
        AccountCategory.equity => 'Ekuitas',
        AccountCategory.revenue => 'Pendapatan',
        AccountCategory.expense => 'Beban',
      };
}

// ── Section list per grup ───────────────────────────────────────────────────

class _GroupSection extends StatelessWidget {
  final AccountGroup group;
  final List<Account> accounts;
  final void Function(Account) onTapAccount;

  const _GroupSection({
    required this.group,
    required this.accounts,
    required this.onTapAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                group.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                '(${accounts.length})',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        ...accounts.map((a) =>
            _AccountTile(account: a, onTap: () => onTapAccount(a))),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Tile akun ───────────────────────────────────────────────────────────────

class _AccountTile extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;

  const _AccountTile({required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            account.accountCode,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          account.name,
          style: TextStyle(
            color: account.isActive ? null : AppColors.textSecondary,
            decoration:
                account.isActive ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(
          '${account.normalBalance == NormalBalance.debit ? "Debit" : "Kredit"} · ${account.isActive ? "Aktif" : "Nonaktif"}',
          style: TextStyle(
            fontSize: 11,
            color: account.isActive
                ? AppColors.textSecondary
                : Colors.red.shade300,
          ),
        ),
        trailing: const Icon(Icons.chevron_right,
            color: AppColors.textSecondary),
        dense: true,
      ),
    );
  }
}
