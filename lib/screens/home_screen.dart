import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_card.dart';
import 'settings_screen.dart';

/// Home hub: greeting + quick access to the main sections.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _editName(BuildContext context) async {
    final appState = context.read<AppState>();
    final controller = TextEditingController(
      text: appState.babyName == 'bebê' ? '' : appState.babyName,
    );
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nome do bebê'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'ex.: Manuela'),
          onSubmitted: (v) => Navigator.of(context).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      appState.updateBabyName(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BabyCare'),
        actions: [
          IconButton(
            onPressed: () => appState.toggleTheme(theme.brightness),
            icon: Icon(
              isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            tooltip: isDark ? 'Tema claro' : 'Tema escuro',
          ),
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            AppCard(
              onTap: () => _editName(context),
              semanticLabel: 'Editar nome do bebê',
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.healthyBg,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.all(6),
                    child: Image.asset('assets/images/baby_icon.png'),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, ${appState.babyName}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Acompanhe crescimento, vacinas e estímulos.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.edit_outlined, color: AppColors.inkMuted),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Seções',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.monitor_weight_outlined,
              color: AppColors.healthyFg,
              background: AppColors.healthyBg,
              title: 'Crescimento',
              subtitle: 'Peso e tamanho com orientação visual.',
              onTap: () => appState.selectTab(1),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.vaccines_outlined,
              color: AppColors.aboveFg,
              background: AppColors.aboveBg,
              title: 'Vacinas',
              subtitle: 'Calendário do PNI e locais de vacinação.',
              onTap: () => appState.selectTab(2),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionTile(
              icon: Icons.music_note_outlined,
              color: AppColors.underFg,
              background: AppColors.underBg,
              title: 'Estímulos',
              subtitle: 'Sons, histórias e cantigas.',
              onTap: () => appState.selectTab(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      semanticLabel: title,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
