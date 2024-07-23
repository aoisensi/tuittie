import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tuittie/src/provider/twitch_credentials_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

final twitchLoginProvider =
    NotifierProvider<TwitchLoginNotifier, Map<String, dynamic>?>(
  TwitchLoginNotifier.new,
);

class TwitchLoginNotifier extends Notifier<Map<String, dynamic>?> {
  @override
  Map<String, dynamic>? build() {
    return null;
  }

  final _clientId = 'v2vdwkonnclvsor3fkjo0c8hg63jor';
  final _scope = 'chat:read chat:edit';

  Future<String> openLoginPage() async {
    final response = await http.post(
      Uri.parse('https://id.twitch.tv/oauth2/device'),
      body: {
        'client_id': _clientId,
        'scope': _scope,
      },
    );
    if (response.statusCode / 100 != 2) {
      throw Exception('Failed to open login page');
    }
    final body = json.decode(response.body);
    await launchUrlString(body['verification_uri']);
    state = body;
    return body['user_code'];
  }

  Future<void> keepTryExchange() async {
    if (state == null) {
      throw Exception('Not opened login page');
    }
    final interval = Duration(seconds: state!['interval']);
    while (true) {
      await Future.delayed(interval);
      final response = await http.post(
        Uri.parse('https://id.twitch.tv/oauth2/token'),
        body: {
          'client_id': _clientId,
          'device_code': state!['device_code'],
          'scope': _scope,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
        },
      );
      if (response.statusCode / 100 == 2) {
        final credentials =
            TwitchCredentials.fromJson(json.decode(response.body));
        ref.read(twitchCredentialsProvider.notifier).save(credentials);
        return;
      }
      final body = json.decode(response.body);
      if (body['message'] != 'authorization_pending') {
        throw Exception('Failed to exchange code');
      }
    }
  }
}
