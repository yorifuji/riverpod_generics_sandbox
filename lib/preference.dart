import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preference.g.dart';

enum Preference<T> {
  counter('counter', 0),
  ;

  const Preference(this.key, this.defaultValue);
  final String key;
  final T defaultValue;
}

@riverpod
class PreferenceNotifier<T> extends _$PreferenceNotifier<T> {
  @override
  T build(Preference<T> pref) {
    return ref.read(sharedPreferencesProvider).getValue(pref);
  }

  Future<void> update(T value) async {
    await ref.read(sharedPreferencesProvider).setValue(pref, value);
    ref.invalidateSelf();
  }
}

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) =>
    throw UnimplementedError();

extension on SharedPreferences {
  T getValue<T>(Preference<T> prefKey) {
    if (prefKey.defaultValue is bool) {
      final value = getBool(prefKey.key);
      return value == null ? prefKey.defaultValue : value as T;
    } else if (prefKey.defaultValue is int) {
      final value = getInt(prefKey.key);
      return value == null ? prefKey.defaultValue : value as T;
    } else if (prefKey.defaultValue is double) {
      final value = getDouble(prefKey.key);
      return value == null ? prefKey.defaultValue : value as T;
    } else if (prefKey.defaultValue is String) {
      final value = getString(prefKey.key);
      return value == null ? prefKey.defaultValue : value as T;
    } else if (prefKey.defaultValue is List<String>) {
      final value = getStringList(prefKey.key);
      return value == null ? prefKey.defaultValue : value as T;
    } else {
      throw UnimplementedError(
        '''SharedPreferencesExt.getValue: unsupported types ${prefKey.defaultValue.runtimeType}''',
      );
    }
  }

  Future<void> setValue<T>(Preference<T> prefKey, T value) {
    if (value is bool) {
      return setBool(prefKey.key, value);
    } else if (value is int) {
      return setInt(prefKey.key, value);
    } else if (value is double) {
      return setDouble(prefKey.key, value);
    } else if (value is String) {
      return setString(prefKey.key, value);
    } else if (value is List<String>) {
      return setStringList(prefKey.key, value);
    } else {
      throw UnimplementedError(
        '''SharedPreferencesExt.setValue: unsupported types ${prefKey.defaultValue.runtimeType}''',
      );
    }
  }
}
