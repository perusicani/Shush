import 'package:Shush/bloc/listening_bloc.dart';
import 'package:Shush/pages/listening_page.dart';
import 'package:Shush/pages/not_listening_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ListeningBloc _listeningBloc;
  double volume;
  double buffer;

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    _listeningBloc = ListeningBloc();
    _listeningBloc.add(StopListening());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shush',
      home: BlocProvider<ListeningBloc>(
        create: (context) => _listeningBloc,
        child: BlocBuilder<ListeningBloc, ListeningState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: state is NotListening
                  ? NotListeningPage(
                      listeningBloc: _listeningBloc,
                      gender: state.gender ?? true,
                    )
                  : ListeningPage(
                      listeningBloc: _listeningBloc,
                    ),
            );
          },
        ),
      ),
    );
  }
}
