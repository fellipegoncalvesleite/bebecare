import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/growth.dart';
import '../services/app_state.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/disclaimer_note.dart';
import '../widgets/empty_state.dart';
import '../widgets/growth_status_card.dart';
import '../widgets/section_header.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weight;
  late final TextEditingController _length;
  late final TextEditingController _age;

  @override
  void initState() {
    super.initState();
    final m = context.read<AppState>().measurement;
    _weight = TextEditingController(text: m != null ? _fmt(m.weightKg) : '');
    _length = TextEditingController(text: m != null ? _fmt(m.lengthCm) : '');
    _age = TextEditingController(text: m?.ageMonths?.toString() ?? '');
  }

  String _fmt(double v) =>
      (v % 1 == 0 ? v.toStringAsFixed(0) : v.toString()).replaceAll('.', ',');

  double? _parse(String raw) =>
      double.tryParse(raw.trim().replaceAll(',', '.'));

  @override
  void dispose() {
    _weight.dispose();
    _length.dispose();
    _age.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final measurement = GrowthMeasurement(
      weightKg: _parse(_weight.text)!,
      lengthCm: _parse(_length.text)!,
      ageMonths: int.tryParse(_age.text.trim()),
    );
    context.read<AppState>().setMeasurement(measurement);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Orientação atualizada.')));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final status = appState.growthStatus;
    final measurement = appState.measurement;

    return Scaffold(
      appBar: AppBar(title: const Text('Crescimento')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            const SectionHeader(
              title: 'Peso e tamanho',
              subtitle:
                  'Uma leitura simples do peso em relação ao tamanho.',
            ),
            if (status != null && measurement != null)
              GrowthStatusCard(status: status, caption: _caption(measurement))
            else
              AppCard(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xl,
                  horizontal: AppSpacing.lg,
                ),
                child: EmptyState(
                  icon: Icons.straighten_rounded,
                  title: 'Sem medidas ainda',
                  message:
                      'Informe o peso e o comprimento atuais para ver a orientação.',
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medidas atuais',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            controller: _weight,
                            label: 'Peso (kg)',
                            hint: 'ex.: 5,8',
                            validator: (v) => _parse(v ?? '') == null
                                ? 'Informe o peso'
                                : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _NumberField(
                            controller: _length,
                            label: 'Comprimento (cm)',
                            hint: 'ex.: 60',
                            validator: (v) => _parse(v ?? '') == null
                                ? 'Informe o tamanho'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _NumberField(
                      controller: _age,
                      label: 'Idade em meses (opcional)',
                      hint: 'ex.: 4',
                      validator: (_) => null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.insights_outlined),
                      label: const Text('Ver orientação'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const DisclaimerNote(
              text:
                  'Essa informação é apenas uma orientação e não '
                  'substitui avaliação médica.',
            ),
          ],
        ),
      ),
    );
  }

  String _caption(GrowthMeasurement m) {
    final parts = <String>[
      '${_fmt(m.weightKg)} kg',
      '${_fmt(m.lengthCm)} cm',
      'IMC ~${m.bmi.toStringAsFixed(1).replaceAll('.', ',')}',
    ];
    return parts.join(' · ');
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      validator: validator,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}
