import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuittie/src/page/home_page.dart';

class Tuittie extends ConsumerWidget {
  const Tuittie({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
