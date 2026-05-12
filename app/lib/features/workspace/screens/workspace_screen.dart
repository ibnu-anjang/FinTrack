import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/auth/auth_provider.dart';
import '../../../models/workspace.dart';
import '../providers/workspace_provider.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacesAsync = ref.watch(userWorkspacesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Pilih Workspace'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Consumer(
              builder: (_, ref, __) {
                final name = ref.watch(userDisplayNameProvider).maybeWhen(
                      data: (n) => n,
                      orElse: () => '...',
                    );
                return Row(
                  children: [
                    const Icon(Icons.account_circle_outlined, size: 16, color: Colors.white70),
                    const SizedBox(width: 6),
                    const Text('Halo, ', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Buat Workspace'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: workspacesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (workspaces) {
          if (workspaces.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.business_outlined, size: 72, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('Belum ada workspace',
                      style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  const Text('Buat workspace untuk mulai mencatat keuangan',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Buat Workspace Pertama'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: workspaces.length,
            separatorBuilder: (context, i) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _WorkspaceCard(
              workspace: workspaces[i],
              onTap: () {
                ref.read(activeWorkspaceProvider.notifier).select(workspaces[i].id);
                context.go('/dashboard');
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _CreateWorkspaceDialog(onCreated: (id) {
        ref.read(activeWorkspaceProvider.notifier).select(id);
        context.go('/dashboard');
      }),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  final Workspace workspace;
  final VoidCallback onTap;
  const _WorkspaceCard({required this.workspace, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.business, color: AppColors.primary),
        ),
        title: Text(workspace.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: workspace.description != null
            ? Text(workspace.description!, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}

class _CreateWorkspaceDialog extends ConsumerStatefulWidget {
  final void Function(String id) onCreated;
  const _CreateWorkspaceDialog({required this.onCreated});

  @override
  ConsumerState<_CreateWorkspaceDialog> createState() => _CreateWorkspaceDialogState();
}

class _CreateWorkspaceDialogState extends ConsumerState<_CreateWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(workspaceProvider).isLoading;

    return AlertDialog(
      title: const Text('Buat Workspace Baru'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Workspace',
                hintText: 'Contoh: Kelas 12A, Toko Budi',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (opsional)',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) return;
                  final id = await ref
                      .read(workspaceProvider.notifier)
                      .createWorkspace(
                        name: _nameCtrl.text,
                        description: _descCtrl.text.isEmpty ? null : _descCtrl.text,
                      );
                  if (id != null && context.mounted) {
                    Navigator.pop(context);
                    widget.onCreated(id);
                  }
                },
          child: isLoading
              ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Buat'),
        ),
      ],
    );
  }
}
