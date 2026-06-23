import 'package:flutter/material.dart';

/// An animal sound entry. [assetPath] is null until a properly licensed audio
/// file is added — the card then shows a "som em breve" placeholder instead of
/// playing anything unlicensed.
class AnimalSound {
  const AnimalSound({
    required this.name,
    required this.emoji,
    required this.source,
    required this.license,
    this.assetPath,
  });

  final String name;
  final String emoji;
  final String? assetPath;

  /// Where the audio comes from (e.g. "Acervo próprio", "Freesound #123").
  final String source;

  /// License under which the audio may be used (e.g. "CC0", "Domínio público").
  final String license;

  bool get hasAudio => assetPath != null;
}

/// A short story shown in the reader. Either an original BabyCare story or a
/// public-domain text — never a copyrighted children's book.
class Story {
  const Story({
    required this.id,
    required this.title,
    required this.ageRange,
    required this.readingMinutes,
    required this.paragraphs,
    required this.origin,
  });

  final String id;
  final String title;
  final String ageRange;
  final int readingMinutes;
  final List<String> paragraphs;

  /// e.g. "História original BabyCare" or "Domínio público".
  final String origin;
}

/// What moment a song suits, used to label cards (never the full lyrics).
enum SongMoment { sleep, play, bath, calm }

extension SongMomentX on SongMoment {
  String get label => switch (this) {
    SongMoment.sleep => 'Dormir',
    SongMoment.play => 'Brincar',
    SongMoment.bath => 'Banho',
    SongMoment.calm => 'Acalmar',
  };

  IconData get icon => switch (this) {
    SongMoment.sleep => Icons.bedtime_outlined,
    SongMoment.play => Icons.toys_outlined,
    SongMoment.bath => Icons.bubble_chart_outlined,
    SongMoment.calm => Icons.spa_outlined,
  };
}

/// A traditional/public-domain song. We store a title + suggested use + a
/// search query to open on an external platform — never copyrighted lyrics.
class Song {
  const Song({
    required this.title,
    required this.moment,
    required this.suggestion,
    required this.searchQuery,
    this.isPublicDomain = true,
  });

  final String title;
  final SongMoment moment;
  final String suggestion;
  final String searchQuery;
  final bool isPublicDomain;
}

enum MediaPlatform { youtube, spotify }

extension MediaPlatformX on MediaPlatform {
  String get label => switch (this) {
    MediaPlatform.youtube => 'YouTube',
    MediaPlatform.spotify => 'Spotify',
  };

  IconData get icon => switch (this) {
    MediaPlatform.youtube => Icons.play_circle_outline,
    MediaPlatform.spotify => Icons.headphones_outlined,
  };
}

/// An external recommendation that opens a search on a platform.
class ExternalMediaLink {
  const ExternalMediaLink({
    required this.label,
    required this.query,
    required this.description,
  });

  final String label;
  final String query;
  final String description;
}
