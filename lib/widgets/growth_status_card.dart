import 'package:flutter/material.dart';

import '../models/growth.dart';
import '../theme/app_tokens.dart';

/// The growth result card.
///
/// The *answer* leads, in plain language: a large status headline, a short
/// explanation, and one concrete next step. The old abstract pointer-gauge has
/// been demoted to a small, self-explanatory labeled scale at the bottom — a
/// graphic is still present, but it no longer carries the meaning on its own
/// (many parents didn't read the abstract pointer correctly).
///
/// The same neutral baby illustration is shown for all three states — only the
/// auxiliary elements change (card tint, status icon, short text). Never a
/// thin/normal/fat caricature.
class GrowthStatusCard extends StatefulWidget {
  const GrowthStatusCard({super.key, required this.status, this.caption});

  final GrowthStatus status;

  /// Optional measurement summary, e.g. "5,8 kg · 60 cm · IMC ~16,1".
  final String? caption;

  @override
  State<GrowthStatusCard> createState() => _GrowthStatusCardState();
}

class _GrowthStatusCardState extends State<GrowthStatusCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entry = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  @override
  void initState() {
    super.initState();
    _entry.forward();
  }

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final theme = Theme.of(context);

    final baby = Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: status.background, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        'assets/images/baby_icon.png',
        fit: BoxFit.contain,
        semanticLabel: 'Ilustração de um bebê',
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: status.foreground.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          // Baby appears with a gentle fade + scale.
          if (reduceMotion)
            baby
          else
            FadeTransition(
              opacity: _entry,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.82, end: 1).animate(
                  CurvedAnimation(parent: _entry, curve: Curves.easeOutBack),
                ),
                child: baby,
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          // The answer, as a plain-language headline — this is the focus.
          Semantics(
            header: true,
            label: 'Situação: ${status.label}',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(status.icon, size: 24, color: status.foreground),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    status.label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: status.foreground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Short explanation, in words.
          Text(
            status.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.ink,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // One concrete next step — the part parents act on.
          _NextStep(text: status.nextStep, accent: status.foreground),
          if (widget.caption != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              widget.caption!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.inkMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          // Demoted graphic: a small, self-explanatory labeled scale.
          _LabeledScale(status: status),
        ],
      ),
    );
  }
}

/// A quiet callout with the single next step, in plain language.
class _NextStep extends StatelessWidget {
  const _NextStep({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.field),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 18, color: accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three named bands (Abaixo / Dentro / Acima) with the matching one
/// highlighted. Replaces the old abstract pointer-on-a-track: it reads the
/// same way whether or not you understand a gauge, and is deliberately small
/// and secondary to the text above.
class _LabeledScale extends StatelessWidget {
  const _LabeledScale({required this.status});

  final GrowthStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label:
              'Faixa em relação ao tamanho: ${status.label}, '
              'de três faixas (abaixo, dentro, acima)',
          child: Row(
            children: [
              _segment(GrowthStatus.underExpected, 'Abaixo'),
              const SizedBox(width: AppSpacing.xs),
              _segment(GrowthStatus.healthyRange, 'Dentro'),
              const SizedBox(width: AppSpacing.xs),
              _segment(GrowthStatus.aboveExpected, 'Acima'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Peso comparado ao tamanho',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.inkMuted,
          ),
        ),
      ],
    );
  }

  Widget _segment(GrowthStatus segment, String label) {
    final active = segment == status;
    final fg = active ? segment.foreground : AppColors.inkMuted;
    // The card itself is tinted with the status color, so the active segment
    // uses a full-white chip with a colored outline to stand out on any tint;
    // inactive segments stay as faint, recessed bands.
    final bg = active
        ? AppColors.surface
        : AppColors.surface.withValues(alpha: 0.5);

    return Expanded(
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadii.field),
            border: Border.all(
              color: active ? segment.foreground : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (active) ...[
                Icon(Icons.check_rounded, size: 13, color: fg),
                const SizedBox(width: 3),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
