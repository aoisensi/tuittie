class TwitchUser {
  final String id;
  final String login;
  final String displayName;
  final String profileImageUrl;

  TwitchUser({
    required this.id,
    required this.login,
    required this.displayName,
    required this.profileImageUrl,
  });

  factory TwitchUser.fromJson(Map<String, dynamic> json) {
    return TwitchUser(
      id: json['id'],
      login: json['login'],
      displayName: json['display_name'],
      profileImageUrl: json['profile_image_url'],
    );
  }
}
