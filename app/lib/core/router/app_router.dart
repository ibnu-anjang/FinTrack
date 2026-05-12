import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/gl/screens/coa_screen.dart';
import '../../features/gl/screens/journal_form_screen.dart';
import '../../features/gl/screens/journal_list_screen.dart';
import '../../features/workspace/providers/workspace_provider.dart';
import '../../features/workspace/screens/workspace_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
class IsRegistering extends _$IsRegistering {
  @override
  bool build() => false;
  void start() => state = true;
  void done() => state = false;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      if (ref.read(isRegisteringProvider)) return null;

      final authAsync = ref.read(authStateProvider);
      final isLoggedIn = authAsync.when(
        data: (user) => user != null,
        loading: () => false,
        error: (_, _) => false,
      );

      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/login' || loc == '/register';
      final isWorkspaceRoute = loc == '/workspaces';

      if (!isLoggedIn && !isAuthRoute) return '/login';

      if (loc == '/register') return null;

      if (isLoggedIn && loc == '/login') return '/workspaces';

      if (isLoggedIn && !isWorkspaceRoute) {
        final workspaceId = ref.read(activeWorkspaceProvider);
        if (workspaceId == null) return '/workspaces';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (ctx, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (ctx, s) => const RegisterScreen()),
      GoRoute(path: '/workspaces', builder: (ctx, s) => const WorkspaceScreen()),
      GoRoute(path: '/dashboard', builder: (ctx, s) => const DashboardScreen()),
      GoRoute(path: '/gl/journal', builder: (ctx, s) => const JournalListScreen()),
      GoRoute(path: '/gl/journal/new', builder: (ctx, s) => const JournalFormScreen()),
      GoRoute(path: '/gl/coa', builder: (ctx, s) => const CoaScreen()),
    ],
  );

  ref.listen(authStateProvider, (_, next) {
    next.whenData((user) {
      if (user == null) {
        ref.read(activeWorkspaceProvider.notifier).clear();
      }
    });
    final currentLoc = router.routerDelegate.currentConfiguration.fullPath;
    print('authState changed, currentLoc: $currentLoc');
    if (currentLoc != '/register') {
      router.refresh();
    }
  });

  return router;
}
