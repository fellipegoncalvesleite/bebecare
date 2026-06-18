import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Builds and opens external search URLs (Google Maps, YouTube, Spotify).
///
/// This is the "Opção A" of the vaccination finder: no API key, works now. We
/// hand the search off to apps the user already trusts instead of scraping.
class ExternalSearch {
  const ExternalSearch();

  /// Google Maps search. When [lat]/[lng] are given, the search is centered on
  /// the user so results are genuinely nearby.
  Uri mapsSearch(String query, {double? lat, double? lng}) {
    final encoded = Uri.encodeComponent(query);
    if (lat != null && lng != null) {
      return Uri.parse(
        'https://www.google.com/maps/search/$encoded/@$lat,$lng,14z',
      );
    }
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );
  }

  Uri youtubeSearch(String query) => Uri.parse(
    'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}',
  );

  Uri spotifySearch(String query) => Uri.parse(
    'https://open.spotify.com/search/${Uri.encodeComponent(query)}',
  );

  /// Launches [uri] in an external app/browser. Returns false if nothing could
  /// handle it (the UI then shows a gentle error).
  Future<bool> open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('ExternalSearch.open failed: $e');
      return false;
    }
  }
}
