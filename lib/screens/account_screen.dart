import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/disclaimer_note.dart';
import '../widgets/section_header.dart';
import 'settings_screen.dart';

/// Parent/account hub: a (fake) sign-in plus the family profile — baby name and
/// the people who care for them. Everything persists locally via [AppState].
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final TextEditingController _name;
  late final TextEditingController _parent1;
  late final TextEditingController _parent2;
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    final s = context.read<AppState>();
    _name = TextEditingController(
      text: s.babyName == 'bebê' ? '' : s.babyName,
    );
    _parent1 = TextEditingController(text: s.parent1Name);
    _parent2 = TextEditingController(text: s.parent2Name);
  }

  @override
  void dispose() {
    _name.dispose();
    _parent1.dispose();
    _parent2.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final s = context.read<AppState>();
    FocusScope.of(context).unfocus();
    s.updateBabyName(_name.text);
    s.setParents(parent1: _parent1.text, parent2: _parent2.text);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil atualizado.')));
  }

  void _login() {
    final email = _email.text.trim();
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um e-mail válido.')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<AppState>().login(email);
    _password.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
        actions: [
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
            _ProfileHeader(
              babyName: appState.babyName,
              email: appState.userEmail,
            ),
            const SizedBox(height: AppSpacing.xl),
            if (appState.isLoggedIn)
              _SignedInCard(
                email: appState.userEmail!,
                onLogout: appState.logout,
              )
            else
              _LoginCard(
                emailController: _email,
                passwordController: _password,
                onLogin: _login,
              ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(
              title: 'Perfil da família',
              subtitle: 'Quem é o bebê e quem cuida.',
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Field(
                    controller: _name,
                    label: 'Nome do bebê',
                    hint: 'ex.: Manuela',
                    icon: Icons.child_care_outlined,
                    capitalize: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _Field(
                    controller: _parent1,
                    label: 'Responsável 1',
                    hint: 'ex.: mãe, pai…',
                    icon: Icons.person_outline,
                    capitalize: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _Field(
                    controller: _parent2,
                    label: 'Responsável 2 (opcional)',
                    hint: 'ex.: mãe, pai…',
                    icon: Icons.person_outline,
                    capitalize: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Salvar'),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.babyName, this.email});

  final String babyName;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = babyName == 'bebê' ? 'Olá!' : 'Família de $babyName';
    return AppCard(
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
                  greeting,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email ?? 'Conta local — não conectada',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignedInCard extends StatelessWidget {
  const _SignedInCard({required this.email, required this.onLogout});

  final String email;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: AppColors.healthyFg),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conectada(o)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.inkMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(onPressed: onLogout, child: const Text('Sair')),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Entrar',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              hintText: 'voce@exemplo.com',
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onLogin,
            icon: const Icon(Icons.login),
            label: const Text('Entrar'),
          ),
          const SizedBox(height: AppSpacing.sm),
          const DisclaimerNote(
            text: 'Login de demonstração — não há servidor, fica salvo só '
                'neste aparelho.',
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.capitalize = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool capitalize;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization:
          capitalize ? TextCapitalization.words : TextCapitalization.none,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
