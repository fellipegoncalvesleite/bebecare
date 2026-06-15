import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Weight-for-length orientation. Deliberately non-clinical and
/// non-caricatural: three neutral bands, never "magro/gordo".
enum GrowthStatus { underExpected, healthyRange, aboveExpected }

extension GrowthStatusX on GrowthStatus {
  String get label => switch (this) {
    GrowthStatus.underExpected => 'Abaixo do esperado',
    GrowthStatus.healthyRange => 'Dentro do esperado',
    GrowthStatus.aboveExpected => 'Acima do esperado',
  };

  String get description => switch (this) {
    GrowthStatus.underExpected =>
      'O peso em relação ao tamanho parece abaixo do esperado. '
          'Acompanhe com um profissional de saúde.',
    GrowthStatus.healthyRange =>
      'O peso em relação ao tamanho parece dentro da faixa esperada.',
    GrowthStatus.aboveExpected =>
      'O peso em relação ao tamanho parece acima do esperado. '
          'Acompanhe com um profissional de saúde.',
  };

  /// A single concrete next step in plain language. This is the part parents
  /// act on — kept short and free of jargon.
  String get nextStep => switch (this) {
    GrowthStatus.underExpected =>
      'Vale conversar com o pediatra na próxima consulta.',
    GrowthStatus.healthyRange =>
      'Continue acompanhando nas consultas de rotina.',
    GrowthStatus.aboveExpected =>
      'Vale conversar com o pediatra na próxima consulta.',
  };

  IconData get icon => switch (this) {
    GrowthStatus.underExpected => Icons.south_rounded,
    GrowthStatus.healthyRange => Icons.check_rounded,
    GrowthStatus.aboveExpected => Icons.north_rounded,
  };

  Color get foreground => switch (this) {
    GrowthStatus.underExpected => AppColors.underFg,
    GrowthStatus.healthyRange => AppColors.healthyFg,
    GrowthStatus.aboveExpected => AppColors.aboveFg,
  };

  Color get background => switch (this) {
    GrowthStatus.underExpected => AppColors.underBg,
    GrowthStatus.healthyRange => AppColors.healthyBg,
    GrowthStatus.aboveExpected => AppColors.aboveBg,
  };

  /// Pointer position on the gauge, 0 (under) → 1 (above).
  double get gaugePosition => switch (this) {
    GrowthStatus.underExpected => 0.16,
    GrowthStatus.healthyRange => 0.5,
    GrowthStatus.aboveExpected => 0.84,
  };
}

/// A single weight/length measurement.
class GrowthMeasurement {
  const GrowthMeasurement({
    required this.weightKg,
    required this.lengthCm,
    this.ageMonths,
  });

  final double weightKg;
  final double lengthCm;
  final int? ageMonths;

  /// Infant body-mass index: weight(kg) / length(m)². Used only as a rough
  /// visual orientation — NOT a WHO z-score and not a diagnosis.
  double get bmi {
    final m = lengthCm / 100.0;
    if (m <= 0) return 0;
    return weightKg / (m * m);
  }

  Map<String, dynamic> toJson() => {
    'weightKg': weightKg,
    'lengthCm': lengthCm,
    'ageMonths': ageMonths,
  };

  static GrowthMeasurement? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final w = (json['weightKg'] as num?)?.toDouble();
    final l = (json['lengthCm'] as num?)?.toDouble();
    if (w == null || l == null) return null;
    return GrowthMeasurement(
      weightKg: w,
      lengthCm: l,
      ageMonths: (json['ageMonths'] as num?)?.toInt(),
    );
  }
}

/// Maps a measurement to a [GrowthStatus]. Thresholds are intentionally
/// conservative and centralised here so they're easy to tune or replace with
/// proper WHO curves later. Treated as guidance only.
class GrowthEstimator {
  GrowthEstimator._();

  // Approximate infant BMI bands (kg/m²). Configurable on purpose.
  static const double lowerBmi = 14.0;
  static const double upperBmi = 18.0;

  static GrowthStatus? estimate(GrowthMeasurement? m) {
    if (m == null) return null;
    if (m.weightKg <= 0 || m.lengthCm <= 0) return null;
    final bmi = m.bmi;
    if (bmi < lowerBmi) return GrowthStatus.underExpected;
    if (bmi > upperBmi) return GrowthStatus.aboveExpected;
    return GrowthStatus.healthyRange;
  }
}
