import 'package:Shush/bloc/listening_bloc.dart';
import 'package:Shush/pages/listening_page.dart';
import 'package:Shush/pages/not_listening_page.dart';

// import 'package:permission_handler/permission_handler.dart';
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

  //probs not neccssary, on start listen sam pita
  // void requestPermission() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.microphone,
  //     Permission.storage,
  //   ].request();
  //   print(statuses.toString());
  // }

  @override
  void initState() {
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
              child: 
                state is NotListening ? NotListeningPage(listeningBloc: _listeningBloc) : ListeningPage(listeningBloc: _listeningBloc) 
              // if (state is NotListening) {
              //   return NotListeningPage(listeningBloc: _listeningBloc);
              // }
              // if (state is Listening) {
              //   return ListeningPage(listeningBloc: _listeningBloc);
              // },
            );
          },
        ),
      ),
    );
  }
}
