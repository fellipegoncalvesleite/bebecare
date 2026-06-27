import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/disclaimer_note.dart';
import '../widgets/section_header.dart';

/// App settings. The appearance/theme control is real (drives [AppState]); the
/// notification toggles are demonstrative only (local, non-persistent) so the
/// screen looks complete without promising a backend that doesn't exist.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Demonstrative switches — not wired to anything real yet.
  bool _vaccineReminders = true;
  bool _weeklyTips = true;
  bool _emailNews = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            const SectionHeader(
              title: 'Aparência',
              subtitle: 'Escolha o tema do aplicativo.',
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ThemeOption(
                    label: 'Padrão do sistema',
                    icon: Icons.brightness_auto_outlined,
                    value: ThemeMode.system,
                    selected: appState.themeMode,
                    onTap: appState.setThemeMode,
                  ),
                  const Divider(height: AppSpacing.lg),
                  _ThemeOption(
                    label: 'Claro',
                    icon: Icons.light_mode_outlined,
                    value: ThemeMode.light,
                    selected: appState.themeMode,
                    onTap: appState.setThemeMode,
                  ),
                  const Divider(height: AppSpacing.lg),
                  _ThemeOption(
                    label: 'Escuro',
                    icon: Icons.dark_mode_outlined,
                    value: ThemeMode.dark,
                    selected: appState.themeMode,
                    onTap: appState.setThemeMode,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(
              title: 'Notificações',
              subtitle: 'Lembretes e novidades.',
            ),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    value: _vaccineReminders,
                    onChanged: (v) => setState(() => _vaccineReminders = v),
                    title: const Text('Lembretes de vacina'),
                    secondary: const Icon(Icons.vaccines_outlined),
                  ),
                  SwitchListTile(
                    value: _weeklyTips,
                    onChanged: (v) => setState(() => _weeklyTips = v),
                    title: const Text('Dicas semanais'),
                    secondary: const Icon(Icons.tips_and_updates_outlined),
                  ),
                  SwitchListTile(
                    value: _emailNews,
                    onChanged: (v) => setState(() => _emailNews = v),
                    title: const Text('Novidades por e-mail'),
                    secondary: const Icon(Icons.mail_outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Sobre'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Versão'),
                    trailing: Text(
                      '1.0.0',
                      style: TextStyle(color: AppColors.inkMuted),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Termos de uso'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showStub(context, 'Termos de uso'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Política de privacidade'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showStub(context, 'Política de privacidade'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const DisclaimerNote(
              text:
                  'Algumas opções desta tela são demonstrativas e ainda não '
                  'têm efeito real.',
            ),
          ],
        ),
      ),
    );
  }

  void _showStub(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Conteúdo de demonstração — em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

/// A single selectable theme row (custom so it themes cleanly and avoids the
/// deprecated Radio group APIs).
class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode selected;
  final ValueChanged<ThemeMode> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return InkWell(
      onTap: () => onTap(value),
      borderRadius: BorderRadius.circular(AppRadii.field),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.inkMuted,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.ink,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary)
            else
              Icon(Icons.circle_outlined, color: AppColors.hairline),
          ],
        ),
      ),
    );
  }
}
