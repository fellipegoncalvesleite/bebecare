import 'package:flutter/material.dart';

import '../models/media.dart';
import '../services/sound_player.dart';
import '../theme/app_tokens.dart';

/// Animal sound tile. Plays the bundled, licensed clip when available; when no
/// audio is bundled yet it shows a "som em breve" state instead of playing
/// anything unlicensed. Reflects the shared player's state (one sound at a time).
class AnimalSoundCard extends StatelessWidget {
  const AnimalSoundCard({super.key, required this.sound});

  final AnimalSound sound;

  Future<void> _onTap(BuildContext context) async {
    if (!sound.hasAudio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Áudio em breve — será adicionado apenas com licença adequada.',
          ),
        ),
      );
      return;
    }
    try {
      await SoundPlayer.instance.toggle(sound.assetPath!);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível tocar o som.')),
        );
      }
    }
  }

  void _showLicense(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${sound.emoji}  ${sound.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fonte: ${sound.source}'),
            const SizedBox(height: 6),
            Text('Licença: ${sound.license}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: AppColors.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _onTap(context),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkResponse(
                  onTap: () => _showLicense(context),
                  radius: 18,
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
              Text(sound.emoji, style: const TextStyle(fontSize: 38)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                sound.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.sm),
              ValueListenableBuilder<String?>(
                valueListenable: SoundPlayer.instance.playing,
                builder: (context, playingPath, _) {
                  final isPlaying =
                      sound.hasAudio && playingPath == sound.assetPath;
                  return _PlayChip(
                    hasAudio: sound.hasAudio,
                    isPlaying: isPlaying,
                    animalName: sound.name,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayChip extends StatelessWidget {
  const _PlayChip({
    required this.hasAudio,
    required this.isPlaying,
    required this.animalName,
  });

  final bool hasAudio;
  final bool isPlaying;
  final String animalName;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String label, Color fg, Color bg) = switch ((
      hasAudio,
      isPlaying,
    )) {
      (false, _) => (
        Icons.hourglass_empty_rounded,
        'Som em breve',
        AppColors.inkMuted,
        AppColors.pendingBg,
      ),
      (true, true) => (
        Icons.stop_rounded,
        'Tocando',
        AppColors.healthyFg,
        AppColors.healthyBg,
      ),
      (true, false) => (
        Icons.play_arrow_rounded,
        'Tocar',
        AppColors.healthyFg,
        AppColors.healthyBg,
      ),
    };

    return Semantics(
      label: isPlaying
          ? 'Parar som de $animalName'
          : hasAudio
          ? 'Tocar som de $animalName'
          : 'Som de $animalName em breve',
      button: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadii.chip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: fg),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
