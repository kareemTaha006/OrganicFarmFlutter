import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/models.dart';
import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../core/widgets/app_widgets.dart';

class ContractsScreen extends ConsumerStatefulWidget {
  const ContractsScreen({super.key});

  @override
  ConsumerState<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends ConsumerState<ContractsScreen> {
  final landController = TextEditingController();
  List<ContractData> items = [];
  ContractData? selected;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(farmRepositoryProvider).contracts();
      ContractData? details = data.isNotEmpty ? data.first : null;
      if (details != null) {
        details = await ref.read(farmRepositoryProvider).contractDetails(details.id) ?? details;
      }
      if (!mounted) return;
      setState(() {
        items = data;
        selected = details;
        landController.text = details?.land?.landNumber ?? '';
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
    if (picked == null) return;
    setState(() => loading = true);
    try {
      final details = await ref.read(farmRepositoryProvider).contractDetails(picked.id) ?? picked;
      if (!mounted) return;
      setState(() {
        selected = details;
        landController.text = details.land?.landNumber ?? '';
        loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      showAppMessage(context, e.message, error: true);
    }
  }

  void _openPdf(String? url, String fallbackError) {
    if (url == null || url.isEmpty) {
      showAppMessage(context, fallbackError, error: true);
      return;
    }
    context.push('/pdf?url=${Uri.encodeQueryComponent(url)}');
  }

  void _openImage(String? url) {
    if (url == null || url.isEmpty) {
      showAppMessage(context, 'Personal ID image not available.', error: true);
      return;
    }
    context.push('/image?url=${Uri.encodeQueryComponent(url)}');
  }

  @override
  void dispose() {
    landController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FarmScaffold(
      title: l10n.contractTitle,
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
            const SizedBox(height: 24),
            _doc(AppAssets.pdf, l10n.sponsorshipContract, () {
              _openPdf(selected?.documents?.sponsorshipContractUrl, 'Invalid sponsorship contract URL.');
            }),
            _doc(AppAssets.pdf, l10n.partnershipContract, () {
              _openPdf(selected?.documents?.participationContractUrl, 'Invalid partnership contract URL.');
            }),
            _doc(AppAssets.memberCard, l10n.personalCard, () {
              _openImage(selected?.documents?.personalIdUrl);
            }),
          ],
        ),
      ),
    );
  }

  Widget _doc(String icon, String label, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: FarmAsset(icon, width: 36, height: 36),
      title: Text(label, style: const TextStyle(fontSize: 17)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
