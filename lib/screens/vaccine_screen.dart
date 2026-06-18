import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/vaccine_schedule.dart';
import '../services/app_state.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/disclaimer_note.dart';
import '../widgets/section_header.dart';
import '../widgets/vaccination_finder_card.dart';
import '../widgets/vaccine_milestone_card.dart';

class VaccineScreen extends StatelessWidget {
  const VaccineScreen({super.key});

  int get _total =>
      vaccineSchedule.fold(0, (sum, item) => sum + item.vaccines.length);

  int _takenCount(AppState state) {
    var taken = 0;
    for (final item in vaccineSchedule) {
      for (final v in item.vaccines) {
        if (state.recordFor(v.id)?.taken ?? false) taken++;
      }
    }
    return taken;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final taken = _takenCount(appState);

    return Scaffold(
      appBar: AppBar(title: const Text('Vacinas')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            const SectionHeader(
              title: 'Vacinas',
              subtitle: 'Calendário Nacional de Vacinação da Criança (PNI).',
            ),
            _ProgressCard(taken: taken, total: _total),
            const SizedBox(height: AppSpacing.lg),
            _BirthDateCard(appState: appState),
            const SizedBox(height: AppSpacing.lg),
            const VaccinationFinderCard(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Calendário por idade',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final item in vaccineSchedule) ...[
              VaccineMilestoneCard(item: item),
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.sm),
            const DisclaimerNote(
              icon: Icons.health_and_safety_outlined,
              text:
                  'O calendário pode variar conforme histórico vacinal, '
                  'campanhas, município, disponibilidade e orientação '
                  'profissional. Consulte a UBS ou profissional de saúde.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.taken, required this.total});

  final int taken;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : taken / total;
    return AppCard(
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: pct,
                  strokeWidth: 5,
                  backgroundColor: AppColors.hairline,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
                Text(
                  '${(pct * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registradas como tomadas',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  '$taken de $total vacinas do calendário',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BirthDateCard extends StatelessWidget {
  const _BirthDateCard({required this.appState});

  final AppState appState;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: appState.birthDate ?? now,
      firstDate: DateTime(now.year - 6),
      lastDate: now,
      helpText: 'Data de nascimento do bebê',
    );
    if (picked != null && context.mounted) {
      appState.setBirthDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final birth = appState.birthDate;
    final months = appState.babyAgeMonths;
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => _pick(context),
      semanticLabel: 'Definir data de nascimento do bebê',
      child: Row(
        children: [
          Icon(Icons.cake_outlined, color: AppColors.primaryDark),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  birth == null
                      ? 'Definir data de nascimento'
                      : 'Nascimento: ${DateFormat('dd/MM/yyyy', 'pt_BR').format(birth)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  birth == null
                      ? 'Ajuda a mostrar o que está próximo ou atrasado.'
                      : '${months ?? 0} meses de vida',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.inkMuted),
        ],
      ),
    );
  }
}
