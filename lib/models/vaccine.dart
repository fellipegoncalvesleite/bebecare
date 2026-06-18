import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// One vaccine within an age milestone.
class VaccineInfo {
  const VaccineInfo({
    required this.id,
    required this.name,
    required this.dose,
    required this.protectsAgainst,
    required this.notes,
    this.requiresProfessionalConfirmation = false,
  });

  /// Stable key used to persist the "taken" record. Never reuse across vaccines.
  final String id;
  final String name;
  final String dose;
  final String protectsAgainst;
  final String notes;

  /// When true, the data could not be fully verified against an official
  /// source and the UI nudges the user to confirm with a professional/UBS.
  final bool requiresProfessionalConfirmation;
}

/// An age milestone grouping one or more vaccines.
class VaccineScheduleItem {
  const VaccineScheduleItem({
    required this.ageLabel,
    required this.ageInMonths,
    required this.vaccines,
  });

  final String ageLabel;

  /// Months from birth (0 = ao nascer). Null when not a fixed month.
  final int? ageInMonths;
  final List<VaccineInfo> vaccines;
}

/// Per-vaccine status. Derived from the schedule + the baby's age + whether the
/// user marked it as taken.
enum VaccineStatus { taken, late, upcoming, pending }

extension VaccineStatusX on VaccineStatus {
  String get label => switch (this) {
    VaccineStatus.taken => 'Tomada',
    VaccineStatus.late => 'Atrasada',
    VaccineStatus.upcoming => 'Próxima',
    VaccineStatus.pending => 'Pendente',
  };

  IconData get icon => switch (this) {
    VaccineStatus.taken => Icons.check_circle_rounded,
    VaccineStatus.late => Icons.error_outline_rounded,
    VaccineStatus.upcoming => Icons.schedule_rounded,
    VaccineStatus.pending => Icons.radio_button_unchecked_rounded,
  };

  Color get foreground => switch (this) {
    VaccineStatus.taken => AppColors.takenFg,
    VaccineStatus.late => AppColors.lateFg,
    VaccineStatus.upcoming => AppColors.upcomingFg,
    VaccineStatus.pending => AppColors.pendingFg,
  };

  Color get background => switch (this) {
    VaccineStatus.taken => AppColors.takenBg,
    VaccineStatus.late => AppColors.lateBg,
    VaccineStatus.upcoming => AppColors.upcomingBg,
    VaccineStatus.pending => AppColors.pendingBg,
  };
}

/// User-tracked record for a single vaccine id (persisted).
class VaccineRecord {
  const VaccineRecord({required this.taken, this.takenDate});

  final bool taken;
  final DateTime? takenDate;

  VaccineRecord copyWith({bool? taken, DateTime? takenDate}) => VaccineRecord(
    taken: taken ?? this.taken,
    takenDate: takenDate ?? this.takenDate,
  );

  Map<String, dynamic> toJson() => {
    'taken': taken,
    'takenDate': takenDate?.toIso8601String(),
  };

  static VaccineRecord fromJson(Map<String, dynamic> json) => VaccineRecord(
    taken: json['taken'] as bool? ?? false,
    takenDate: json['takenDate'] != null
        ? DateTime.tryParse(json['takenDate'] as String)
        : null,
  );
}

/// Derives the status for a vaccine given the baby's age and its record.
/// [milestoneMonths] is the recommended age; [babyAgeMonths] may be null if the
/// user hasn't entered a birth date yet (then non-taken vaccines are "pending").
VaccineStatus deriveVaccineStatus({
  required int? milestoneMonths,
  required int? babyAgeMonths,
  required VaccineRecord? record,
}) {
  if (record?.taken ?? false) return VaccineStatus.taken;
  if (babyAgeMonths == null || milestoneMonths == null) {
    return VaccineStatus.pending;
  }
  // Grace window: considered "late" only after the recommended age passes.
  if (babyAgeMonths > milestoneMonths) return VaccineStatus.late;
  if (babyAgeMonths >= milestoneMonths - 1) return VaccineStatus.upcoming;
  return VaccineStatus.pending;
}
