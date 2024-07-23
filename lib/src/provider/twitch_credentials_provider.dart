import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuittie/src/provider/preferences_provider.dart';

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
