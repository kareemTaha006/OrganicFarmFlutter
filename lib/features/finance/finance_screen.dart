import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/models.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/widgets/app_widgets.dart';
import 'excel_opener.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {
  final landController = TextEditingController();
  List<FinancialData> items = [];
  FinancialData? selected;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(farmRepositoryProvider).financials();
      setState(() {
        items = data;
        selected = data.isNotEmpty ? data.first : null;
        landController.text = selected?.land?.landNumber ?? '';
        loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      showAppMessage(context, e.message, error: true);
    }
  }

  Future<void> _pick() async {
    final picked = await showLandPicker(
      context: context,
      items: items,
      label: (item) => item.land?.landNumber ?? '',
      selected: selected,
    );
    if (picked != null) {
      setState(() {
        selected = picked;
        landController.text = picked.land?.landNumber ?? '';
      });
    }
  }

  Future<void> _openExcel() async {
    final url = selected?.fileUrl;
    if (url == null || url.isEmpty) {
      showAppMessage(context, 'Invalid file URL.', error: true);
      return;
    }
    setState(() => loading = true);
    try {
      await openExcelFile(url);
    } catch (e) {
      if (mounted) showAppMessage(context, e.toString(), error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    landController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = selected?.records ?? [];
    return FarmScaffold(
      title: l10n.financials,
      child: LoadingOverlay(
        visible: loading,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            AppField(
              label: l10n.landNumber,
              controller: landController,
              readOnly: true,
              onTap: _pick,
              suffix: const Icon(Icons.arrow_drop_down),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                onPressed: _openExcel,
                icon: const FarmAsset(AppAssets.excel, width: 36, height: 36),
              ),
            ),
            ...records.map(
              (record) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '${record.month}  ${record.date}  ${record.amount}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
