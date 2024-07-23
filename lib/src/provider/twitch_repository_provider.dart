import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tuittie/src/entity/twitch_user.dart';
import 'package:tuittie/src/provider/twitch_credentials_provider.dart';

import '../constant.dart';

final twitchRepositoryProvider = Provider<TwitchRepository>(
  TwitchRepository.new,
);

class TwitchRepository {
  TwitchRepository(this.ref);

  final Ref ref;

  final _endpoint = 'https://api.twitch.tv/helix/';

  Future<List<TwitchUser>> getUsers([List<String> id = const []]) async {
    // todo implement parameter
    final response = await _get('users');
    print(response.body);
    if (response.statusCode / 100 != 2) {
      throw Exception('Failed to get users');
    }
    return json.decode(response.body)['data'].map<TwitchUser>((e) {
      return TwitchUser.fromJson(e);
    }).toList();
  }

  Future<http.Response> _get(String path) async {
    final accessToken = await _accessToken;
    return http.get(
      Uri.parse('$_endpoint$path'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Client-Id': twitchClientId,
      },
    );
  }

  Future<String> get _accessToken =>
      ref.read(twitchCredentialsProvider.notifier).getAccessToken();
}
