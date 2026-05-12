import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/user_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/workspace/providers/workspace_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (_, ref, __) {
            final workspaceId = ref.watch(activeWorkspaceProvider);
            final workspacesAsync = ref.watch(userWorkspacesProvider);
            final name = workspacesAsync.maybeWhen(
              data: (list) => list.where((w) => w.id == workspaceId).firstOrNull?.name,
              orElse: () => null,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('FinTrack', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                if (name != null)
                  Text(name, style: const TextStyle(fontSize: 12, color: AppColors.onPrimary)),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Ganti Workspace',
            onPressed: () {
              ref.read(activeWorkspaceProvider.notifier).clear();
              context.go('/workspaces');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          _AccountInfoCard(),
          const SizedBox(height: 16),
          Text('General Ledger', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _MenuCard(
            icon: Icons.receipt_long,
            title: 'Daftar Jurnal',
            subtitle: 'Lihat dan buat jurnal akuntansi',
            onTap: () => context.push('/gl/journal'),
          ),
          _MenuCard(
            icon: Icons.account_tree_outlined,
            title: 'Chart of Accounts',
            subtitle: 'Kelola daftar akun',
            onTap: () => context.push('/gl/coa'),
          ),
          const SizedBox(height: 24),
          Text('Modul Lain', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _MenuCard(icon: Icons.receipt, title: 'AR & Sales', subtitle: 'Segera hadir', onTap: null),
          _MenuCard(icon: Icons.shopping_cart, title: 'AP & Purchases', subtitle: 'Segera hadir', onTap: null),
          _MenuCard(icon: Icons.inventory_2, title: 'Inventory', subtitle: 'Segera hadir', onTap: null),
          _MenuCard(icon: Icons.assessment, title: 'Laporan Keuangan', subtitle: 'Segera hadir', onTap: null),
        ],
      ),
    );
  }
}

class _AccountInfoCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = ref.watch(userDisplayNameProvider).maybeWhen(
          data: (n) => n,
          orElse: () => '...',
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text('Halo, ', style: Theme.of(context).textTheme.bodySmall),
          Expanded(
            child: Text(
              displayName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _MenuCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: enabled ? AppColors.primary.withValues(alpha: 0.1) : AppColors.divider,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: enabled ? AppColors.primary : AppColors.textSecondary, size: 22),
        ),
        title: Text(title, style: TextStyle(color: enabled ? AppColors.textPrimary : AppColors.textSecondary)),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: enabled ? const Icon(Icons.chevron_right, color: AppColors.textSecondary) : null,
        onTap: onTap,
      ),
    );
  }
}
