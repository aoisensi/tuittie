import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuittie/src/provider/preferences_provider.dart';
import 'package:tuittie/src/tuittie.dart';

Future<void> main() async {
  final sp = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sp),
      ],
      child: const Tuittie(),
    ),
  );
}
