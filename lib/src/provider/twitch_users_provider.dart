import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuittie/src/entity/twitch_user.dart';
import 'package:tuittie/src/provider/twitch_repository_provider.dart';

final twitchSelfUserProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(twitchRepositoryProvider);
  final user = (await repository.getUsers()).first;
  final userNotifier = ref.watch(twitchUserFamilyProvider(user.id).notifier);
  userNotifier.put(user);
  return user.id;
});

final twitchUserFamilyProvider =
    AsyncNotifierProvider.family<TwitchUserNotifier, TwitchUser, String>(
        TwitchUserNotifier.new);

class TwitchUserNotifier extends FamilyAsyncNotifier<TwitchUser, String> {
  @override
  FutureOr<TwitchUser> build(String arg) {
    return future;
  }

  Future<void> fetch() async {
    try {
      final repository = ref.read(twitchRepositoryProvider);
      final user = await repository.getUsers([arg]);
      put(user.first);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  put(TwitchUser user) {
    state = AsyncValue.data(user);
  }
}
