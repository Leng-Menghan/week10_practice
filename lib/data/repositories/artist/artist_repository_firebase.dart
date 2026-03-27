import 'dart:convert';

import 'package:http/http.dart' as http;
 
import '../../../model/artist/artist.dart';
import '../../config/firebase_config.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  List<Artist>? _cachedArtists;

  final Uri artistsUri = FirebaseConfig.baseUri.replace(path: "artists.json");

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    // 1. Return cache if available
    if (_cachedArtists!= null && !forceFetch) {
        return _cachedArtists!;
    }

    // 2. Otherwise fetch from API
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in songJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }
    // 3. Store in memory
      _cachedArtists = result;

      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {}
}
