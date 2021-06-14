extension NxStringExtension on String {
  String withVars(Map vars) {
    // Sort like [b, aa, a], so replacing 'a' will not affect 'aa'.
    final entries = vars.entries.toList();
    entries.sort((e1, e2) => e2.key.toString().compareTo(e1.key.toString()));

    return entries.fold<String>(
        this,
        (res, entry) => res.replaceAll(
            r'$' + entry.key.toString(), entry.value.toString()));
  }
}
