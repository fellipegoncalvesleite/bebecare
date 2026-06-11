import 'package:flutter/material.dart';

/// Design tokens for BabyCare.
///
/// One small, deliberate palette: teal for trust/care, a peach accent that
/// echoes the baby illustration, and three *muted* status colors that are
/// never alarmist. Status is always communicated with an icon + text as well,
/// so color is never the only signal (acessibilidade).
///
/// The same semantic tokens exist in a [light] and a [dark] variant. Widgets
/// keep reading them through [AppColors] (e.g. `AppColors.surface`); the active
/// variant is swapped at the app root via [AppColors.apply] whenever the
/// resolved brightness changes, so every screen follows the theme for free.
class AppPalette {
  const AppPalette({
    required this.primary,
    required this.primaryDark,
    required this.accent,
    required this.accentSoft,
    required this.background,
    required this.surface,
    required this.ink,
    required this.inkMuted,
    required this.hairline,
    required this.underFg,
    required this.underBg,
    required this.healthyFg,
    required this.healthyBg,
    required this.aboveFg,
    required this.aboveBg,
    required this.pendingFg,
    required this.pendingBg,
    required this.lateFg,
    required this.lateBg,
    required this.brightness,
  });

  final Color primary;
  final Color primaryDark;
  final Color accent;
  final Color accentSoft;

  final Color background;
  final Color surface;
  final Color ink;
  final Color inkMuted;
  final Color hairline;

  final Color underFg;
  final Color underBg;
  final Color healthyFg;
  final Color healthyBg;
  final Color aboveFg;
  final Color aboveBg;

  final Color pendingFg;
  final Color pendingBg;
  final Color lateFg;
  final Color lateBg;

  final Brightness brightness;

  // Vaccine "taken" reuses the healthy pair; "upcoming" reuses the above pair.
  Color get takenFg => healthyFg;
  Color get takenBg => healthyBg;
  Color get upcomingFg => aboveFg;
  Color get upcomingBg => aboveBg;
}

const AppPalette lightPalette = AppPalette(
  brightness: Brightness.light,
  // Brand
  primary: Color(0xFF4F9D8F),
  primaryDark: Color(0xFF2F6F62),
  accent: Color(0xFFE8A87C), // warm peach
  accentSoft: Color(0xFFF6D9C0),
  // Surfaces / ink
  background: Color(0xFFF6F8F7),
  surface: Colors.white,
  ink: Color(0xFF1B2D2A),
  inkMuted: Color(0xFF63746F),
  hairline: Color(0xFFE4EAE7),
  // Growth status (under = amber, healthy = teal, above = soft blue)
  underFg: Color(0xFFC98A2E),
  underBg: Color(0xFFFBF1E0),
  healthyFg: Color(0xFF3E8E7E),
  healthyBg: Color(0xFFE5F1ED),
  aboveFg: Color(0xFF5B86C9),
  aboveBg: Color(0xFFE7EEF8),
  // Vaccine status
  pendingFg: Color(0xFF63746F),
  pendingBg: Color(0xFFEDF1EF),
  lateFg: Color(0xFFC0603C), // terracotta, caution
  lateBg: Color(0xFFFBE9E1),
);

/// Dark variant — same calm character, lifted off a deep teal-charcoal.
/// Foregrounds are brightened for contrast; status tints become low-luminance
/// versions of their light selves so they still read as "the amber/teal/blue
/// one" without glowing.
const AppPalette darkPalette = AppPalette(
  brightness: Brightness.dark,
  // Brand
  primary: Color(0xFF62B6A6),
  primaryDark: Color(0xFF9AD8CB), // light teal — used as text/icon on dark
  accent: Color(0xFFECB089),
  accentSoft: Color(0xFF3A2C22),
  // Surfaces / ink
  background: Color(0xFF0F1C1A),
  surface: Color(0xFF182A27),
  ink: Color(0xFFE9F1EF),
  inkMuted: Color(0xFF9DB0AB),
  hairline: Color(0xFF294039),
  // Growth status
  underFg: Color(0xFFE0B675),
  underBg: Color(0xFF33291A),
  healthyFg: Color(0xFF79C7B6),
  healthyBg: Color(0xFF1C3A33),
  aboveFg: Color(0xFF8FB4E8),
  aboveBg: Color(0xFF1E2F49),
  // Vaccine status
  pendingFg: Color(0xFF9DB0AB),
  pendingBg: Color(0xFF243531),
  lateFg: Color(0xFFE89B7C),
  lateBg: Color(0xFF3B261D),
);

/// The active palette, swapped at runtime by [apply]. Reads go through these
/// getters so existing `AppColors.x` call sites keep working unchanged.
class AppColors {
  AppColors._();

  static AppPalette _p = lightPalette;

  /// Point the tokens at the light or dark variant. Called from the app root
  /// whenever the resolved theme brightness changes.
  static void apply(Brightness brightness) {
    _p = brightness == Brightness.dark ? darkPalette : lightPalette;
  }

  static Brightness get brightness => _p.brightness;

  static Color get primary => _p.primary;
  static Color get primaryDark => _p.primaryDark;
  static Color get accent => _p.accent;
  static Color get accentSoft => _p.accentSoft;

  static Color get background => _p.background;
  static Color get surface => _p.surface;
  static Color get ink => _p.ink;
  static Color get inkMuted => _p.inkMuted;
  static Color get hairline => _p.hairline;

  static Color get underFg => _p.underFg;
  static Color get underBg => _p.underBg;
  static Color get healthyFg => _p.healthyFg;
  static Color get healthyBg => _p.healthyBg;
  static Color get aboveFg => _p.aboveFg;
  static Color get aboveBg => _p.aboveBg;

  static Color get pendingFg => _p.pendingFg;
  static Color get pendingBg => _p.pendingBg;
  static Color get takenFg => _p.takenFg;
  static Color get takenBg => _p.takenBg;
  static Color get lateFg => _p.lateFg;
  static Color get lateBg => _p.lateBg;
  static Color get upcomingFg => _p.upcomingFg;
  static Color get upcomingBg => _p.upcomingBg;
}

/// 4-pt based spacing scale used across cards and sections.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
}

class AppRadii {
  AppRadii._();
  static const double card = 18;
  static const double chip = 999;
  static const double field = 14;

  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get fieldRadius => BorderRadius.circular(field);
}
