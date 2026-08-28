import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/session/session.dart';
import '../../core/widgets/app_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final name = ref.watch(sessionProvider).user?.displayName ?? '';

    return FarmScaffold(
      showClose: false,
      trailing: IconButton(
        onPressed: () => context.push('/settings'),
        icon: const FarmAsset(AppAssets.settings, width: 26, height: 26),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          children: [
            Text(
              '${l10n.hello}$name',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 28,
                crossAxisSpacing: 20,
                childAspectRatio: 1.15,
                children: [
                  MenuTile(
                    icon: AppAssets.plant,
                    label: l10n.earthData,
                    onTap: () => context.push('/land'),
                  ),
                  MenuTile(
                    icon: AppAssets.contract,
                    label: l10n.contracts,
                    onTap: () => context.push('/contracts'),
                  ),
                  MenuTile(
                    icon: AppAssets.media,
                    label: l10n.picturesVideos,
                    onTap: () => context.push('/media'),
                  ),
                  MenuTile(
                    icon: AppAssets.technicalOp,
                    label: l10n.technicalOperations,
                    onTap: () => context.push('/operations'),
                  ),
                  MenuTile(
                    icon: AppAssets.production,
                    label: l10n.production,
                    onTap: () => context.push('/production'),
                  ),
                  MenuTile(
                    icon: AppAssets.financial,
                    label: l10n.financialAccounts,
                    onTap: () => context.push('/finance'),
                  ),
                  MenuTile(
                    icon: AppAssets.contactUs,
                    label: l10n.communication,
                    onTap: () => context.push('/contact'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
