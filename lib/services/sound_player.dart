import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Plays the bundled animal sounds — one at a time, which suits a baby app.
///
/// [playing] holds the asset path currently sounding (or null). Widgets can
/// listen to it to reflect play/stop state without each owning a player.
class SoundPlayer {
  SoundPlayer._() {
    _player.onPlayerComplete.listen((_) => playing.value = null);
  }

  static final SoundPlayer instance = SoundPlayer._();

  final AudioPlayer _player = AudioPlayer();

  /// Asset path (relative to `assets/`, e.g. `audio/animals/dog.mp3`) that is
  /// currently playing, or null.
  final ValueNotifier<String?> playing = ValueNotifier<String?>(null);

  /// Plays [assetPath], or stops it if it is already playing (toggle).
  Future<void> toggle(String assetPath) async {
    if (playing.value == assetPath) {
      await stop();
      return;
    }
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
      playing.value = assetPath;
    } catch (e) {
      debugPrint('SoundPlayer failed for $assetPath: $e');
      playing.value = null;
      rethrow;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    playing.value = null;
  }
}
