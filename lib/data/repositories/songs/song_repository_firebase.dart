import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../config/firebase_config.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {

  @override
  Future<List<Song>> fetchSongs() async {
    final Uri songsUriGet = FirebaseConfig.baseUri.replace(path: "/songs.json");
    final http.Response response = await http.get(songsUriGet);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}
  
  @override
  Future<void> likeSong(String id, int currentLikes) async {
    final Uri songsUriUpdate = FirebaseConfig.baseUri.replace(path: "/songs/$id.json");
    final http.Response response = await http.patch(
      songsUriUpdate,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"likes": currentLikes}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to like song");
    }
  }
}
