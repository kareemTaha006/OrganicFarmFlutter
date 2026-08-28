import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/session/session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(sessionProvider).locale.languageCode;

    Future<void> select(String code) async {
      await ref.read(sessionProvider.notifier).setLanguage(Locale(code));
      if (context.mounted) context.go('/dashboard');
    }

    Widget langButton(String code, String label) {
      final selected = current == code;
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: selected ? AppColors.primary : Colors.white,
            foregroundColor: selected ? Colors.white : AppColors.text,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => select(code),
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
      );
    }

    return FarmScaffold(
      title: l10n.selectLang,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            langButton('en', l10n.english),
            const SizedBox(height: 16),
            langButton('ar', l10n.arabic),
          ],
        ),
      ),
    );
  }
}
