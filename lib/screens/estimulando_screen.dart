import 'package:flutter/material.dart';

import '../data/media_data.dart';
import '../models/media.dart';
import '../services/external_search.dart';
import '../theme/app_tokens.dart';
import '../widgets/animal_sound_card.dart';
import '../widgets/app_card.dart';
import '../widgets/disclaimer_note.dart';
import '../widgets/song_card.dart';
import '../widgets/story_card.dart';
import 'story_reader_screen.dart';

/// Sons de animais, histórias e cantigas — tudo respeitando direitos autorais
/// (áudio só com licença; histórias originais/domínio público; cantigas
/// tradicionais com links externos, sem letras protegidas).
class EstimulandoScreen extends StatelessWidget {
  const EstimulandoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estímulos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sons'),
              Tab(text: 'Histórias'),
              Tab(text: 'Cantigas'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [_SoundsTab(), _StoriesTab(), _SongsTab()],
          ),
        ),
      ),
    );
  }
}

class _SoundsTab extends StatelessWidget {
  const _SoundsTab();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(AppSpacing.lg),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.82,
      children: [
        for (final sound in animalSounds) AnimalSoundCard(sound: sound),
      ],
    );
  }
}

class _StoriesTab extends StatelessWidget {
  const _StoriesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        for (final story in stories) ...[
          StoryCard(
            story: story,
            onRead: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StoryReaderScreen(story: story),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const DisclaimerNote(
          icon: Icons.auto_stories_outlined,
          text:
              'Histórias originais do BabyCare ou de domínio público. Não '
              'reproduzimos livros protegidos por direitos autorais.',
        ),
      ],
    );
  }
}

class _SongsTab extends StatelessWidget {
  const _SongsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        for (final song in songs) ...[
          SongCard(song: song),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Ouvir e assistir mais',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final rec in externalRecommendations) ...[
          _ExternalRecCard(rec: rec),
          const SizedBox(height: AppSpacing.md),
        ],
        const DisclaimerNote(
          icon: Icons.visibility_outlined,
          text:
              'Confira sempre o conteúdo antes de deixar a criança assistir ou '
              'ouvir. Evite telas por longos períodos e prefira áudio calmo.',
        ),
      ],
    );
  }
}

class _ExternalRecCard extends StatelessWidget {
  const _ExternalRecCard({required this.rec});

  final ExternalMediaLink rec;

  static const _search = ExternalSearch();

  Future<void> _open(BuildContext context, MediaPlatform platform) async {
    final uri = switch (platform) {
      MediaPlatform.youtube => _search.youtubeSearch(rec.query),
      MediaPlatform.spotify => _search.spotifySearch(rec.query),
    };
    final ok = await _search.open(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o ${platform.label}.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rec.label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            rec.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.inkMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _open(context, MediaPlatform.youtube),
                  icon: const Icon(Icons.play_circle_outline, size: 18),
                  label: const Text('YouTube'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _open(context, MediaPlatform.spotify),
                  icon: const Icon(Icons.headphones_outlined, size: 18),
                  label: const Text('Spotify'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
