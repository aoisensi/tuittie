import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuittie/src/fragment/login_fragment.dart';
import 'package:tuittie/src/provider/twitch_users_provider.dart';

import '../provider/twitch_login_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(twitchIsLoggedInProvider);
    return Scaffold(
      appBar: AppBar(
        title: isLoggedIn
            ? const Text('Tuittie')
            : const Text('Tuittie (ログインしてください)'),
        actions: [
          isLoggedIn
              ? Consumer(builder: (context, ref, child) {
                  final isLoggedIn = ref.watch(twitchIsLoggedInProvider);
                  if (!isLoggedIn) {
                    return const SizedBox();
                  }

                  final id = ref.watch(twitchSelfUserProvider);
                  if (id.isLoading) {
                    return const IconButton(
                      onPressed: null,
                      icon: CircularProgressIndicator(),
                    );
                  }
                  final user =
                      ref.watch(twitchUserFamilyProvider(id.value!)).value!;

                  return IconButton(
                    icon: CircleAvatar(
                      backgroundImage: NetworkImage(user.profileImageUrl),
                    ),
                    onPressed: () {},
                  );
                })
              : const SizedBox(),
        ],
      ),
      body: isLoggedIn
          ? const Center(child: Text('ログインしました'))
          : const LoginFragment(),
    );
  }
}
