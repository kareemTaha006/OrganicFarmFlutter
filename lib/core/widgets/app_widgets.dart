import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class FarmAsset extends StatelessWidget {
  const FarmAsset(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  Widget _fallback() {
    return Icon(
      Icons.eco_outlined,
      color: AppColors.primary,
      size: width ?? height ?? 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (_) => _fallback(),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }
}

class FarmScaffold extends StatelessWidget {
  const FarmScaffold({
    super.key,
    required this.child,
    this.title,
    this.showClose = true,
    this.onClose,
    this.authBackground = false,
    this.trailing,
  });

  final Widget child;
  final String? title;
  final bool showClose;
  final VoidCallback? onClose;
  final bool authBackground;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FarmAsset(
            authBackground ? AppAssets.backgroundAuth : AppAssets.backgroundCore,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  child: Row(
                    children: [
                      if (showClose)
                        IconButton(
                          onPressed: onClose ?? () => Navigator.of(context).maybePop(),
                          icon: const FarmAsset(AppAssets.close, width: 22, height: 22),
                        )
                      else
                        const SizedBox(width: 48),
                      Expanded(
                        child: title == null
                            ? const SizedBox.shrink()
                            : Text(
                                title!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text,
                                ),
                              ),
                      ),
                      trailing ?? const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Text(label),
    );
  }
}

class AppField extends StatelessWidget {
  const AppField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (visible)
          const ColoredBox(
            color: AppColors.overlay,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            flex: 2,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 74,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  child: FarmAsset(AppAssets.bgIcon, fit: BoxFit.contain),
                ),
                FarmAsset(icon, width: 56, height: 56),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: FarmAsset(icon, width: 28, height: 28),
      title: Text(label, style: const TextStyle(fontSize: 18)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

void showAppMessage(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error ? AppColors.error : AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<T?> showLandPicker<T>({
  required BuildContext context,
  required List<T> items,
  required String Function(T item) label,
  T? selected,
}) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.landNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final selectedItem = selected == item;
                  return ListTile(
                    title: Text(label(item)),
                    trailing: selectedItem ? const Icon(Icons.check, color: AppColors.primary) : null,
                    onTap: () => Navigator.pop(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
