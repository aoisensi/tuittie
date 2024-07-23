import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tuittie/src/provider/preferences_provider.dart';

import '../constant.dart';

final twitchCredentialsProvider =
    NotifierProvider<TwitchCredentialsNotifier, TwitchCredentials?>(
  TwitchCredentialsNotifier.new,
);

class TwitchCredentialsNotifier
    extends PreferencesNotifier<TwitchCredentials?, String> {
  TwitchCredentialsNotifier() : super('twitch_credentials');

  @override
  String? encode(TwitchCredentials? value) {
    return value?.toJson();
  }

  @override
  TwitchCredentials? decode(String? data) {
    return data == null ? null : TwitchCredentials.fromJson(json.decode(data));
  }

  Future<String> getAccessToken() async {
    if (state == null) {
      throw Exception('Not authorized');
    }
    if (state!.expiresAt.isAfter(DateTime.now())) {
      return state!.accessToken;
    }
    final response = await http.post(
      Uri.parse('https://id.twitch.tv/oauth2/token'),
      body: {
        'client_id': twitchClientId,
        'refresh_token': state!.refreshToken,
        'grant_type': 'refresh_token',
      },
    );
    if (response.statusCode / 100 != 2) {
      throw Exception('Failed to refresh token');
    }
    final credentials = TwitchCredentials.fromJson(json.decode(response.body));
    save(credentials);
    return credentials.accessToken;
  }

  bool get isAuthorized => state != null;
}

class TwitchCredentials {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  TwitchCredentials(this.accessToken, this.refreshToken, this.expiresAt);

  factory TwitchCredentials.fromJson(Map<String, dynamic> json) {
    return TwitchCredentials(
      json['access_token'],
      json['refresh_token'],
      json['expires_in'] != null
          ? DateTime.now().add(Duration(seconds: json['expires_in'] as int))
          : DateTime.parse(json['expires_at'] as String),
    );
  }

  String toJson() {
    return jsonEncode({
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
    });
  }
}
