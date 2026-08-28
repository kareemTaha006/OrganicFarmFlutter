import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/session/session.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/contact/contact_screen.dart';
import 'features/contracts/contracts_screen.dart';
import 'features/contracts/pdf_viewer_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/finance/finance_screen.dart';
import 'features/land/land_screen.dart';
import 'features/language/language_screen.dart';
import 'features/media/image_detail_screen.dart';
import 'features/media/media_screen.dart';
import 'features/media/video_player_screen.dart';
import 'features/operations/operations_screen.dart';
import 'features/production/production_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: ref.read(sessionProvider).isLoggedIn ? '/dashboard' : '/login',
    refreshListenable: _SessionRefresh(ref),
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      if (!session.ready) return null;
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';
      if (!session.isLoggedIn && !loggingIn) return '/login';
      if (session.isLoggedIn && loggingIn) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/language', builder: (context, state) => const LanguageScreen()),
      GoRoute(path: '/land', builder: (context, state) => const LandScreen()),
      GoRoute(path: '/contracts', builder: (context, state) => const ContractsScreen()),
      GoRoute(
        path: '/pdf',
        builder: (context, state) => PdfViewerScreen(url: state.uri.queryParameters['url'] ?? ''),
      ),
      GoRoute(
        path: '/image',
        builder: (context, state) =>
            ImageDetailScreen(url: state.uri.queryParameters['url'] ?? ''),
      ),
      GoRoute(
        path: '/video',
        builder: (context, state) =>
            VideoPlayerScreen(url: state.uri.queryParameters['url'] ?? ''),
      ),
      GoRoute(path: '/operations', builder: (context, state) => const OperationsScreen()),
      GoRoute(path: '/production', builder: (context, state) => const ProductionScreen()),
      GoRoute(path: '/finance', builder: (context, state) => const FinanceScreen()),
      GoRoute(path: '/media', builder: (context, state) => const MediaScreen()),
      GoRoute(path: '/contact', builder: (context, state) => const ContactScreen()),
    ],
  );
});

class _SessionRefresh extends ChangeNotifier {
  _SessionRefresh(this.ref) {
    ref.listen(sessionProvider, (_, __) => notifyListeners());
  }

  final Ref ref;
}
