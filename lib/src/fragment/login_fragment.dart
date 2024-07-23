import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/twitch_login_provider.dart';

class LoginFragment extends HookConsumerWidget {
  const LoginFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCode = useState<String?>(null);
    final loginNotifier = ref.read(twitchLoginProvider.notifier);
    ref.watch(twitchLoginProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            userCode.value = await loginNotifier.openLoginPage();
            await loginNotifier.keepTryExchange();
          },
          child: const Text('連携画面を開く'),
        ),
        Text(userCode.value ?? '', style: const TextStyle(fontSize: 24)),
      ],
    );
  }
}
