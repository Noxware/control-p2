import 'package:control_p2/repositories/organizer.dart';
import 'package:control_p2/repositories/settings.dart';
import 'package:control_p2/screens/organizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/organizer_cubit.dart';
import 'widgets/split_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => OrganizerCubit(
          organizerRepository: OrganizerRepository(
            settingsRepository: SettingsRepository(),
          ),
        )..init(),
        child: Organizer(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SplitView(
          first: Container(
            alignment: Alignment.center,
            //color: Colors.red,
            child: Text('Hola'),
          ),
          second: SplitView(
            first: Container(
              alignment: Alignment.center,
              //color: Colors.green,
              child: Text('Mundo'),
            ),
            second: Container(
              alignment: Alignment.center,
              //color: Colors.purple,
              child: Text('!'),
            ),
          ),
          ratio: 0.2,
        ),
      ),
    );
  }
}
