import 'package:flutter/material.dart';

class FriendlyError extends StatelessWidget {
  final Object? error;
  final Object? stackTrace;

  const FriendlyError({
    Key? key,
    required this.error,
    required this.stackTrace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$error\n\n$stackTrace');
  }
}
