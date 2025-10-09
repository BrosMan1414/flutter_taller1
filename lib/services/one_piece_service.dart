import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/character.dart';

class OnePieceService {
  static const String endpoint = 'https://onepieceql.up.railway.app/graphql';

  // GraphQL query to fetch characters
  static const String charactersQuery = r'''
    query Characters {
      characters {
        results {
          englishName
          age
          birthday
          bounty
          devilFruitName
          avatarSrc
        }
      }
    }
  ''';

  final http.Client _client;
  OnePieceService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Character>> fetchCharacters() async {
    try {
      final response = await _client.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': charactersQuery}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (data['errors'] != null) {
        // GraphQL returned errors
        final err = data['errors'];
        throw Exception('GraphQL error: $err');
      }

      final results = (data['data']?['characters']?['results'] as List?) ?? [];
      return results
          .map((e) => Character.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      if (kDebugMode) {
        print('fetchCharacters error: $e\n$st');
      }
      rethrow;
    }
  }
}
