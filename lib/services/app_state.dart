import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/growth.dart';
import '../models/vaccine.dart';

/// App-wide state, persisted with shared_preferences.
///
/// Holds the baby profile (name + birth date), the latest growth measurement
/// and the per-vaccine "taken" records. Call [load] once at startup.
class AppState extends ChangeNotifier {
  AppState({SharedPreferences? prefs}) : _prefs = prefs;

  static const _kName = 'baby_name';
  static const _kBirth = 'baby_birth';
  static const _kGrowth = 'growth_measurement';
  static const _kVaccines = 'vaccine_records';
  static const _kTheme = 'theme_mode';
  static const _kParent1 = 'parent1_name';
  static const _kParent2 = 'parent2_name';
  static const _kEmail = 'user_email';

  SharedPreferences? _prefs;

  int _selectedIndex = 0;
  String _babyName = 'bebê';
  DateTime? _birthDate;
  GrowthMeasurement? _measurement;
  ThemeMode _themeMode = ThemeMode.system;
  String _parent1Name = '';
  String _parent2Name = '';
  String? _userEmail;
  final Map<String, VaccineRecord> _vaccineRecords = {};

  // --- getters ---
  int get selectedIndex => _selectedIndex;
  ThemeMode get themeMode => _themeMode;
  String get parent1Name => _parent1Name;
  String get parent2Name => _parent2Name;
  String? get userEmail => _userEmail;
  bool get isLoggedIn => _userEmail != null;
  String get babyName => _babyName;
  DateTime? get birthDate => _birthDate;
  GrowthMeasurement? get measurement => _measurement;
  GrowthStatus? get growthStatus => GrowthEstimator.estimate(_measurement);

  /// Baby age in whole months, or null if no birth date is set.
  int? get babyAgeMonths {
    final birth = _birthDate;
    if (birth == null) return null;
    final now = DateTime.now();
    var months = (now.year - birth.year) * 12 + (now.month - birth.month);
    if (now.day < birth.day) months -= 1;
    return months < 0 ? 0 : months;
  }

  VaccineRecord? recordFor(String vaccineId) => _vaccineRecords[vaccineId];

  /// Loads persisted state. Safe to call before runApp.
  Future<void> load() async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    _babyName = prefs.getString(_kName) ?? 'bebê';
    final birthRaw = prefs.getString(_kBirth);
    _birthDate = birthRaw != null ? DateTime.tryParse(birthRaw) : null;

    final themeRaw = prefs.getString(_kTheme);
    _themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == themeRaw,
      orElse: () => ThemeMode.system,
    );

    _parent1Name = prefs.getString(_kParent1) ?? '';
    _parent2Name = prefs.getString(_kParent2) ?? '';
    _userEmail = prefs.getString(_kEmail);

    final growthRaw = prefs.getString(_kGrowth);
    if (growthRaw != null) {
      try {
        _measurement = GrowthMeasurement.fromJson(
          jsonDecode(growthRaw) as Map<String, dynamic>,
        );
      } catch (_) {
        _measurement = null;
      }
    }

    final vaccinesRaw = prefs.getString(_kVaccines);
    if (vaccinesRaw != null) {
      try {
        final map = jsonDecode(vaccinesRaw) as Map<String, dynamic>;
        _vaccineRecords.clear();
        map.forEach((key, value) {
          _vaccineRecords[key] = VaccineRecord.fromJson(
            value as Map<String, dynamic>,
          );
        });
      } catch (_) {
        _vaccineRecords.clear();
      }
    }
    notifyListeners();
  }

  // --- mutations ---
  void selectTab(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs?.setString(_kTheme, mode.name);
  }

  /// Flip between light and dark based on what's currently showing.
  Future<void> toggleTheme(Brightness current) =>
      setThemeMode(
        current == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
      );

  Future<void> updateBabyName(String name) async {
    final normalized = name.trim();
    if (normalized.isEmpty || normalized == _babyName) return;
    _babyName = normalized;
    notifyListeners();
    await _prefs?.setString(_kName, _babyName);
  }

  Future<void> setParents({String? parent1, String? parent2}) async {
    if (parent1 != null) _parent1Name = parent1.trim();
    if (parent2 != null) _parent2Name = parent2.trim();
    notifyListeners();
    await _prefs?.setString(_kParent1, _parent1Name);
    await _prefs?.setString(_kParent2, _parent2Name);
  }

  /// Fake sign-in: there's no backend — we just remember the email locally so
  /// the account screen can show a "signed in" state.
  Future<void> login(String email) async {
    _userEmail = email.trim();
    notifyListeners();
    await _prefs?.setString(_kEmail, _userEmail!);
  }

  Future<void> logout() async {
    _userEmail = null;
    notifyListeners();
    await _prefs?.remove(_kEmail);
  }

  Future<void> setBirthDate(DateTime? date) async {
    _birthDate = date;
    notifyListeners();
    if (date == null) {
      await _prefs?.remove(_kBirth);
    } else {
      await _prefs?.setString(_kBirth, date.toIso8601String());
    }
  }

  Future<void> setMeasurement(GrowthMeasurement? measurement) async {
    _measurement = measurement;
    notifyListeners();
    if (measurement == null) {
      await _prefs?.remove(_kGrowth);
    } else {
      await _prefs?.setString(_kGrowth, jsonEncode(measurement.toJson()));
    }
  }

  Future<void> setVaccineTaken(
    String vaccineId, {
    required bool taken,
    DateTime? date,
  }) async {
    if (taken) {
      _vaccineRecords[vaccineId] = VaccineRecord(
        taken: true,
        takenDate: date ?? DateTime.now(),
      );
    } else {
      _vaccineRecords.remove(vaccineId);
    }
    notifyListeners();
    await _persistVaccines();
  }

  Future<void> _persistVaccines() async {
    final map = _vaccineRecords.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    await _prefs?.setString(_kVaccines, jsonEncode(map));
  }
}
