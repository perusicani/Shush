import 'package:Shush/bloc/currentnoiselvl_bloc.dart';
import 'package:Shush/bloc/listening_bloc.dart';
import 'package:Shush/pages/listening_page.dart';
import 'package:Shush/pages/not_listening_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ListeningBloc _listeningBloc;
  double volume;
  double buffer;

  CurrentnoiselvlBloc _currentnoiselvlBloc;

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    _listeningBloc = ListeningBloc();
    _currentnoiselvlBloc = CurrentnoiselvlBloc();
    _listeningBloc.add(StopListening());
    _currentnoiselvlBloc.add(StartListeningCurrentNoiseLvl());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shush',
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListeningBloc>( 
              create: (context) => _listeningBloc),
          BlocProvider<CurrentnoiselvlBloc>(
              create: (context) => _currentnoiselvlBloc)
        ],
        child: BlocBuilder<ListeningBloc, ListeningState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: state is NotListening
                  ? NotListeningPage(
                      listeningBloc: _listeningBloc,
                      gender: state.gender ?? true,
                      currentnoiselvlBloc: _currentnoiselvlBloc,
                    )
                  : ListeningPage(
                      listeningBloc: _listeningBloc,
                      currentnoiselvlBloc: _currentnoiselvlBloc,
                    ),
            );
          },
        ),
      ),
    );
  }
}
