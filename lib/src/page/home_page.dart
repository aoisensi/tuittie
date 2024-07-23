import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuittie/src/fragment/login_fragment.dart';

import '../provider/twitch_credentials_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twitchCredentials = ref.watch(twitchCredentialsProvider.notifier);
    final cred = ref.watch(twitchCredentialsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(cred?.toJson() ?? '未ログイン'),
      ),
      body: Center(
        child: twitchCredentials.isAuthorized
            ? const Text('ログイン済み')
            : LoginFragment(),
      ),
    );
  }
}
