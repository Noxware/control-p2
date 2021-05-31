extension NxStringExtension on String {
  String withVars(Map vars) {
    return vars.entries.fold<String>(
        this,
        (res, entry) => res.replaceAll(
            r'$' + entry.key.toString(), entry.value.toString()));
  }
}
