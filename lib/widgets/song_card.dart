import 'package:flutter/material.dart';

import '../models/media.dart';
import '../services/external_search.dart';
import '../theme/app_tokens.dart';
import 'app_card.dart';

/// A traditional/public-domain song. We never show full lyrics — just a title,
/// suggested use, and buttons that open the song on an external platform.
class SongCard extends StatelessWidget {
  const SongCard({super.key, required this.song});

  final Song song;

  static const _search = ExternalSearch();

  Future<void> _open(BuildContext context, MediaPlatform platform) async {
    final uri = switch (platform) {
      MediaPlatform.youtube => _search.youtubeSearch(song.searchQuery),
      MediaPlatform.spotify => _search.spotifySearch(song.searchQuery),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  song.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _MomentChip(moment: song.moment),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            song.suggestion,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.inkMuted,
              height: 1.35,
            ),
          ),
          if (song.isPublicDomain) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Cantiga tradicional / domínio público',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.inkMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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

class _MomentChip extends StatelessWidget {
  const _MomentChip({required this.moment});

  final SongMoment moment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(moment.icon, size: 14, color: AppColors.ink),
          const SizedBox(width: 5),
          Text(
            moment.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
