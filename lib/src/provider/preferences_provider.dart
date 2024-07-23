import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

class PreferencesNotifier<T, S> extends Notifier<T> {
  final String key;

  PreferencesNotifier(this.key);

  @override
  T build() {
    final sp = ref.read(sharedPreferencesProvider);
    return decode(sp.get(key) as S?);
  }

  S? encode(T value) {
    return value as S?;
  }

  T decode(S? data) {
    return data as T;
  }

  void save(T value) async {
    final sp = ref.read(sharedPreferencesProvider);
    final data = encode(value);
    if (data == null) {
      await sp.remove(key);
      state = value;
      return;
    }
    switch (data) {
      case bool data:
        await sp.setBool(key, data);
        break;
      case int data:
        await sp.setInt(key, data);
        break;
      case double data:
        await sp.setDouble(key, data);
        break;
      case String data:
        await sp.setString(key, data);
        break;
      case List<String> data:
        await sp.setStringList(key, data);
        break;
      default:
        throw UnimplementedError();
    }
    state = value;
  }
}
