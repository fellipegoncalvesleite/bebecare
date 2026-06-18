import 'package:flutter/material.dart';

import '../services/external_search.dart';
import '../services/location_service.dart';
import '../theme/app_tokens.dart';
import 'app_card.dart';
import 'section_header.dart';

/// "Buscar vacinação perto de você" (Parte 3, Opção A).
///
/// Asks for location; on success it centers external Maps searches on the user.
/// Every failure mode (serviço desligado, negado, negado permanentemente, erro)
/// is handled and there is always a manual city/bairro fallback — the card
/// never dead-ends.
class VaccinationFinderCard extends StatefulWidget {
  const VaccinationFinderCard({super.key});

  @override
  State<VaccinationFinderCard> createState() => _VaccinationFinderCardState();
}

enum _FinderState {
  idle,
  loading,
  located,
  serviceDisabled,
  denied,
  deniedForever,
  error,
}

class _VaccinationFinderCardState extends State<VaccinationFinderCard> {
  static const _location = LocationService();
  static const _search = ExternalSearch();

  final _manualController = TextEditingController();
  _FinderState _state = _FinderState.idle;
  double? _lat;
  double? _lng;

  static const _terms = <String>[
    'posto de vacinação perto de mim',
    'UBS vacinação infantil',
    'campanha de vacinação infantil perto de mim',
  ];

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  Future<void> _requestLocation() async {
    setState(() => _state = _FinderState.loading);
    final result = await _location.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      switch (result.outcome) {
        case LocationOutcome.success:
          _lat = result.position!.latitude;
          _lng = result.position!.longitude;
          _state = _FinderState.located;
        case LocationOutcome.serviceDisabled:
          _state = _FinderState.serviceDisabled;
        case LocationOutcome.denied:
          _state = _FinderState.denied;
        case LocationOutcome.deniedForever:
          _state = _FinderState.deniedForever;
        case LocationOutcome.error:
          _state = _FinderState.error;
      }
    });
  }

  Future<void> _openSearch(String query) async {
    final uri = _search.mapsSearch(query, lat: _lat, lng: _lng);
    final ok = await _search.open(uri);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o mapa neste dispositivo.'),
        ),
      );
    }
  }

  void _searchManual() {
    final place = _manualController.text.trim();
    final query = place.isEmpty
        ? 'posto de vacinação'
        : 'posto de vacinação $place';
    _openSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: 'Buscar vacinação perto de você',
            subtitle: 'Encontre UBS, postos ou campanhas de vacinação.',
          ),
          _buildBody(context),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Buscar por cidade ou bairro',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _manualController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchManual(),
                  decoration: const InputDecoration(
                    hintText: 'ex.: Centro, Belo Horizonte',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Semantics(
                button: true,
                label: 'Buscar manualmente por cidade ou bairro',
                child: IconButton.filledTonal(
                  onPressed: _searchManual,
                  icon: const Icon(Icons.search),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _GuidanceNote(),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_state) {
      case _FinderState.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              ),
              SizedBox(width: AppSpacing.md),
              Text('Obtendo sua localização…'),
            ],
          ),
        );
      case _FinderState.located:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InlineNote(
              icon: Icons.my_location,
              color: AppColors.healthyFg,
              background: AppColors.healthyBg,
              text:
                  'Localização ativa. As buscas vão considerar onde você está.',
            ),
            const SizedBox(height: AppSpacing.md),
            for (final term in _terms) ...[
              OutlinedButton.icon(
                onPressed: () => _openSearch(term),
                icon: const Icon(Icons.travel_explore_outlined),
                label: Text(term, textAlign: TextAlign.left),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        );
      case _FinderState.serviceDisabled:
        return _ProblemBody(
          message:
              'A localização do aparelho está desligada. Ative-a e tente de novo, '
              'ou busque manualmente abaixo.',
          primaryLabel: 'Tentar de novo',
          onPrimary: _requestLocation,
        );
      case _FinderState.denied:
        return _ProblemBody(
          message:
              'Sem permissão de localização. Você pode permitir e tentar de novo, '
              'ou buscar manualmente abaixo.',
          primaryLabel: 'Permitir localização',
          onPrimary: _requestLocation,
        );
      case _FinderState.deniedForever:
        return _ProblemBody(
          message:
              'A permissão de localização foi bloqueada. Abra as configurações '
              'para liberar, ou busque manualmente abaixo.',
          primaryLabel: 'Abrir configurações',
          onPrimary: _location.openSettings,
        );
      case _FinderState.error:
        return _ProblemBody(
          message:
              'Não conseguimos obter a localização agora. Tente de novo ou busque '
              'manualmente abaixo.',
          primaryLabel: 'Tentar de novo',
          onPrimary: _requestLocation,
        );
      case _FinderState.idle:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ative a localização para encontrarmos UBS, postos ou campanhas de '
              'vacinação perto de você.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: _requestLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Permitir localização'),
            ),
          ],
        );
    }
  }
}

class _ProblemBody extends StatelessWidget {
  const _ProblemBody({
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
  });

  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InlineNote(
          icon: Icons.location_off_outlined,
          color: AppColors.lateFg,
          background: AppColors.lateBg,
          text: message,
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: onPrimary,
          icon: const Icon(Icons.refresh),
          label: Text(primaryLabel),
        ),
      ],
    );
  }
}

class _InlineNote extends StatelessWidget {
  const _InlineNote({
    required this.icon,
    required this.color,
    required this.background,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.field),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidanceNote extends StatelessWidget {
  const _GuidanceNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Nem sempre eventos aparecem online. Procure também a UBS mais próxima, a '
      'Secretaria Municipal de Saúde ou o conteúdo oficial do seu município.',
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.inkMuted, height: 1.4),
    );
  }
}
