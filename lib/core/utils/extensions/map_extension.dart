extension MapDynamicExtension on Map<String, dynamic> {
  bool hasKey(String key) => containsKey(key);

  bool hasValue(String key) => this[key] != null;

  bool getBool(String key) => this[key] as bool? ?? false;

  String getString(String key) => this[key] as String? ?? '';

  T? getValue<T>({required String key, T? defaultValue}) =>
      this[key] as T? ?? defaultValue;
}
