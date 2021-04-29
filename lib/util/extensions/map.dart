extension NxMapExtension<K, V> on Map<K, V> {
  Map<K, V> filter(bool Function(MapEntry<K, V> e) test) {
    final res = <K, V>{};

    for (final e in this.entries) {
      if (test(e)) {
        res[e.key] = e.value;
      }
    }

    return res;
  }

  Map<K, V> withoutKeys(Iterable<K> keys) {
    final res = Map<K, V>.from(this);

    for (final k in keys) {
      res.remove(k);
    }

    return res;
  }
}
